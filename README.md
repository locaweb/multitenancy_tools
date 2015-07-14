# MultitenancyTools

This gem is a collection of tools that can be used to handle multitenant
Ruby/Rails apps. The currently only supported database is PostgreSQL.

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

#### How to dump the structure of a schema to a SQL file

You can dump the structure of a PostgreSQL schema using the following code:

```ruby
dumper = MultitenancyTools::SchemaDumper.new('<database name>', '<schema name>')
dumper.dump_to('path/to/file.sql')
```

Please note that `pg_dump` must be on your PATH, otherwise this will fail.

#### How to dump the content of a table to a SQL file

You can dump the content of a table using the following code:

```ruby
dumper = MultitenancyTools::TableDumper.new('<database name>', '<schema name>', '<table>')
dumper.dump_to('path/to/file.sql')
```

Please note that `pg_dump` must be on your PATH, otherwise this will fail.

#### How to create a new schema using SQL as template

To create a new PostgreSQL schema using a SQL template, you need an
ActiveRecord connection:

```ruby
creator = MultitenancyTools::SchemaCreator.new('schema_name', ActiveRecord::Base.connection)
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

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/multitenancy_tools.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
