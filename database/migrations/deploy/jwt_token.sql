-- Deploy postgrest:jwt_token to pg
-- requires: initroles

BEGIN;
CREATE EXTENSION if not exists pgcrypto;

CREATE OR REPLACE FUNCTION auth.url_encode(data bytea) RETURNS text LANGUAGE sql AS $$
    SELECT translate(encode(data, 'base64'), E'+/=\n', '-_');
$$;

CREATE OR REPLACE FUNCTION auth.url_decode(data text) RETURNS bytea LANGUAGE sql AS $$
    WITH t AS (
        SELECT 
            translate(data, '-_', '+/') 
            AS trans
    ),
    rem AS (
        SELECT 
            length(t.trans) % 4 AS remainder 
        FROM t
    ) -- compute padding size
    SELECT 
        decode(
            t.trans ||
            CASE WHEN rem.remainder > 0
            THEN repeat('=', (4 - rem.remainder))
            ELSE '' END, 'base64'
        ) 
    FROM t, rem;
$$;


CREATE OR REPLACE FUNCTION auth.algorithm_sign(signables text, secret text, algorithm text)
RETURNS text LANGUAGE sql AS $$
    WITH alg AS (
        SELECT 
        CASE
            WHEN algorithm = 'HS256' THEN 'sha256'
            WHEN algorithm = 'HS384' THEN 'sha384'
            WHEN algorithm = 'HS512' THEN 'sha512'
            ELSE '' 
        END AS id
    )  -- hmac throws error
    SELECT 
        auth.url_encode(hmac(signables, secret, alg.id)) 
    FROM alg;
$$;


CREATE OR REPLACE FUNCTION auth.sign(payload json, secret text, algorithm text DEFAULT 'HS256') RETURNS text LANGUAGE sql AS $$
WITH
header AS (
    SELECT 
        auth.url_encode(convert_to('{"alg":"' || algorithm || '","typ":"JWT"}', 'utf8')) AS data
),
payload AS (
    SELECT auth.url_encode(convert_to(payload::text, 'utf8')) AS data
),
signables AS (
    SELECT header.data || '.' || payload.data AS data FROM header, payload
)
SELECT
    signables.data || '.' || auth.algorithm_sign(signables.data, secret, algorithm) 
FROM signables;
$$;


CREATE OR REPLACE FUNCTION auth.verify(token text, secret text, algorithm text DEFAULT 'HS256') RETURNS table(header json, payload json, valid boolean) LANGUAGE sql AS $$
SELECT
    convert_from(auth.url_decode(r[1]), 'utf8')::json AS header,
    convert_from(auth.url_decode(r[2]), 'utf8')::json AS payload,
    r[3] = auth.algorithm_sign(r[1] || '.' || r[2], secret, algorithm) AS valid
FROM regexp_split_to_array(token, '\.') r;
$$;

CREATE TYPE auth.jwt_token AS (
    token text
);

-- SET SESSION 'app.jwt_secret' to 'secret'
CREATE FUNCTION auth.jwt_claim(role_in text DEFAULT 'web_anon') RETURNS auth.jwt_token AS $$
    SELECT auth.sign(
        row_to_json(r), current_setting('postgrest.jwt_secret')
    ) AS token
    FROM (
        SELECT
            role_in as role
            ,extract(epoch from now())::integer + 300 AS exp
            ,current_setting('request.header.user-agent', true)::text as user_agent
    ) r;
$$ LANGUAGE sql;
CREATE OR REPLACE FUNCTION auth.check_user() RETURNS void AS $$
BEGIN
  IF current_user = 'api_user' THEN
    RAISE EXCEPTION 'web_anon only user allowed. access denied for %', current_user
      USING HINT = 'try without authentication?';
  END IF;
END
$$ LANGUAGE plpgsql;



grant execute on function 
    auth.url_encode
    ,auth.url_decode 
    ,auth.algorithm_sign
    ,auth.sign
    ,auth.verify
    ,auth.jwt_claim
    ,hmac(bytea, bytea, text)
    ,hmac(text, text, text)
    ,auth.check_user
to web_anon;
grant execute on function 
    auth.check_user
to authenticator;

grant execute on function 
    auth.check_user
to api_user;

COMMIT;
