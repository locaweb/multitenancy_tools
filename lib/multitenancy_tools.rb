require 'multitenancy_tools/version'
require 'multitenancy_tools/errors'
require 'multitenancy_tools/dump_cleaner'
require 'multitenancy_tools/schema_dumper'
require 'multitenancy_tools/schema_creator'
require 'multitenancy_tools/table_dumper'
require 'multitenancy_tools/schema_switcher'

module MultitenancyTools
  # Uses the passed schema as the scope for all queries triggered by the block.
  #
  # @param schema [String] schema name
  # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
  # @yield The block that must be executed using the schema as scope
  def self.using(schema, connection = ActiveRecord::Base.connection, &block)
    SchemaSwitcher.new(schema, connection).run(&block)
  end
end
