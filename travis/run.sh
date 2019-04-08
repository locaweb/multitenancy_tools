#!/bin/bash

set -e

gem install bundler
cp spec/database.yml.travis spec/database.yml

bundle exec rspec
