# MultitenancyTools

This gem is a collection of tools that can be used to handle multitenant
Ruby/Rails apps. It was written for PostgreSQL backends.

With this gem you can:

* Create SQL dumps of PostgreSQL schemas.
* Create a new PostgreSQL schema using a SQL template.

(More comming soon.)

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

### Dump a schema structure to a SQL file

To create a SQL dump of a PostgreSQL schema structure:

```ruby
dumper = MultitenancyTools::SchemaDumper.new('database_name', 'schema_name')
File.open('dump.sql', 'w') do |f|
  dumper.dump_to(f)
end
```

Please note that `pg_dump` must be on your PATH because it is a dependency of
this class.

### Create a new schema using a SQL template

To create a new PostgreSQL schema using a SQL template, you must pass an
ActiveRecord connection:

```ruby
creator = MultitenancyTools::SchemaCreator.new('schema_name', ActiveRecord::Base.connection)
creator.from_sql('path/to/file.sql')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
edit `spec/database.yml` with your PostgreSQL database connection details.
Please note that this database will *be destroyed and recreated* on test
execution.

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

