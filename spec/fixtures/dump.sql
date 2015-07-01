SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_with_oids = false;
CREATE TABLE posts (
    id integer NOT NULL,
    title text,
    body text
);
CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE posts_id_seq OWNED BY posts.id;
CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);
ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);
