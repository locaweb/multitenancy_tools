require 'active_support/core_ext/kernel/reporting'

module MultitenancyTools
  # {SchemaMigrator} is a wrapper around ActiveRecord::Migrator that executes
  # all migrations inside a PostgreSQL schema.
  #
  # Unfortunately this can only execute migrations using the global connection
  # (the connection returned by ActiveRecord::Base.connection).
  #
  # @example
  #   migrator = MultitenancyTools::SchemaMigrator.new('my_schema', 'path/to/migrations')
  #   migrator.migrate
  class SchemaMigrator
    # @param schema [String] schema name
    # @param migrations_path [String] path to the migrations files
    def initialize(schema, migrations_path)
      @schema = schema
      @migrations_path = migrations_path
    end

    # Executes all migrations.
    def migrate
      run do
        ActiveRecord::Migrator.migrate(@migrations_path, nil)
      end
    end

    # Undo the latest migration.
    def rollback
      run do
        ActiveRecord::Migrator.rollback(@migrations_path)
      end
    end

    private

    def run(&block)
      SchemaSwitcher.new(@schema, ActiveRecord::Base.connection).run do
        silence_stream(STDOUT) do
          yield
        end
      end
    end
  end
end
