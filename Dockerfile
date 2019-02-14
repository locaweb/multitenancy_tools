FROM ruby:2.0

ARG uid

RUN apt-get update && apt-get install -y postgresql-client

RUN useradd -M -u $uid filhao
USER filhao
