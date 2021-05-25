-- Deploy postgrest:apischema to pg
-- depends on 

BEGIN;

CREATE SCHEMA api;

GRANT USAGE ON SCHEMA api TO web_anon;
GRANT USAGE ON SCHEMA api TO api_user;

COMMIT;
