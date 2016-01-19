CREATE ROLE ctx WITH PASSWORD <password> LOGIN;
CREATE DATABASE ctx_server_sample;
GRANT ALL ON DATABASE ctx_server_sample TO ctx;

CREATE TABLE items (
       id integer,
       title varchar(255),
       description text,
       price integer
);
CREATE INDEX ON items (id);

-- # # Import items data
-- # CSV was from http://dbs.uni-leipzig.de/en/research/projects/object_matching/fever/benchmark_datasets_for_entity_resolution
-- psql -d ctx_server_sample -c "COPY items FROM '/Users/Takenos/CtxServerSample/resources/items.csv' delimiter ',' csv;"

CREATE TABLE users (
       id serial,
       screen_name varchar(255),
       password_digest bytea
);
CREATE INDEX ON users (id);
CREATE INDEX ON users (screen_name);