# MultitenancyTools

[![Build Status][travis-badge]][travis-build]
[![Code Climate][cc-badge]][cc-details]
[![Test Coverage][cc-cov-badge]][cc-cov-details]

This Ruby gem is a collection of tools that can be used to handle multitenant
Ruby/Rails apps. Like the name says, it is just a collection of tools and not
an opinionated implementation and does not require a specific architecture.

The currently only supported database is PostgreSQL and there is no plan to
support other databases.

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

#### Dumping from a different host and using a different username
```ruby
options = { host: 'db-on-docker', username: 'non-root-user' }
dumper = MultitenancyTools::SchemaDumper.new('database name', 'schema name', options)
dupmer.dump_to('path/to/file.sql')
```

### Dumping the content of a table to a SQL file

Like `SchemaDumper`, this tool also requires `pg_dump` to be on the `PATH`:

```ruby
dumper = MultitenancyTools::TableDumper.new('database name', 'schema name', 'table name')
dumper.dump_to('path/to/file.sql')
```

#### Dumping from a different host and using a different username
```ruby
options = { host: 'db-on-docker', username: 'non-root-user' }
dumper = MultitenancyTools::TableDumper.new('database name', 'schema name', 'table_name', options)
dupmer.dump_to('path/to/file.sql')
```

### Creating a new PostgreSQL schema using a SQL file as template

After using `SchemaDumper` to create the SQL template, you can use the following
class to create a new schema using this file as template:

```ruby
creator = MultitenancyTools::SchemaCreator.new('schema name', ActiveRecord::Base.connection)
creator.create_from_file('path/to/file.sql')
```

## Development

After checking out the repo:

1. Install dependencies using `bin/setup`.
2. Create the file `spec/database.yml` and configure it with your PostgreSQL
database. There is an example on `spec/database.yml.example`. **Important:**
this database *will be destroyed and recreated* on test execution.
3. Run specs using `bundle exec rake spec` to make sure that everything is fine.

You can use `bin/console` to get an interactive prompt that will allow you to
experiment.

## Releasing a new version

If you are the maintainer of this project:

1. Update the version number in `lib/multitenancy_tools/version.rb`.
2. Make sure that all tests are green (run `bundle exec rake spec`).
3. Execute `bundle exec rake release` to create a git tag for the version, push
git commits and tags, and publish the gem on [RubyGems.org][rubygems].

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
[rubygems]: https://rubygems.org/gems/multitenancy_tools
