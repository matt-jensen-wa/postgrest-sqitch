-- Revert postgrest:jwt_token from pg

BEGIN;

DROP FUNCTION auth.check_user;
DROP FUNCTION auth.jwt_claim;
DROP FUNCTION auth.url_encode;
DROP FUNCTION auth.url_decode;
DROP FUNCTION auth.algorithm_sign;
DROP FUNCTION auth.sign;
DROP FUNCTION auth.verify;
drop type auth.jwt_token;
DROP EXTENSION if exists pgcrypto;

COMMIT;
