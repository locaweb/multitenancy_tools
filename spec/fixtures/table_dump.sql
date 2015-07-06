SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
INSERT INTO posts VALUES (1, 'foo bar baz', 'post content');
SELECT pg_catalog.setval('posts_id_seq', 1, true);
