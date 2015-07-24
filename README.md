# MultitenancyTools

[![Build Status][travis-badge]][travis-build]
[![Code Climate][cc-badge]][cc-details]
[![Test Coverage][cc-cov-badge]][cc-cov-details]

This Ruby gem is a collection of tools that can be used to handle multitenant
Ruby/Rails apps. The currently only supported database is PostgreSQL and there
is no plan to support other databases.

The documentation is [available on RubyDoc.info][docs].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multitenancy_tools'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install multitenancy_tools

## Usage

### Dumping the structure of a PostgreSQL schema to a SQL file

Please note that `pg_dump` must be on your `PATH`:

```ruby
dumper = MultitenancyTools::SchemaDumper.new('database name', 'schema name')
dumper.dump_to('path/to/file.sql')
```

### Dumping the content of a table to a SQL file

Like `SchemaDumper`, this tool also requires `pg_dump` to be on the `PATH`:

```ruby
dumper = MultitenancyTools::TableDumper.new('database name', 'schema name', 'table name')
dumper.dump_to('path/to/file.sql')
```

### Creating a new PostgreSQL schema using a SQL file as template

After using `SchemaDumper` to create the SQL template, you can use the following
class to create a new schema using this file as template:

```ruby
creator = MultitenancyTools::SchemaCreator.new('schema name', ActiveRecord::Base.connection)
creator.create_from_file('path/to/file.sql')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
edit `spec/database.yml` with your PostgreSQL database connection details (take
a look at the example in `spec/database.yml.example`). **IMPORTANT:** this
database will *be destroyed and recreated* on test execution.

You can use `rake spec` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/locaweb/multitenancy_tools.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

[travis-badge]: https://travis-ci.org/locaweb/multitenancy_tools.svg?branch=master
[travis-build]: https://travis-ci.org/locaweb/multitenancy_tools
[cc-badge]: https://codeclimate.com/github/locaweb/multitenancy_tools/badges/gpa.svg
[cc-details]: https://codeclimate.com/github/locaweb/multitenancy_tools
[cc-cov-badge]: https://codeclimate.com/github/locaweb/multitenancy_tools/badges/coverage.svg
[cc-cov-details]: https://codeclimate.com/github/locaweb/multitenancy_tools/coverage
[docs]: http://www.rubydoc.info/gems/multitenancy_tools
