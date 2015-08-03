require 'multitenancy_tools/version'
require 'multitenancy_tools/errors'
require 'multitenancy_tools/dump_cleaner'
require 'multitenancy_tools/schema_dumper'
require 'multitenancy_tools/schema_creator'
require 'multitenancy_tools/table_dumper'
require 'multitenancy_tools/schema_switcher'

module MultitenancyTools
  # Uses the tenant to perform all queries executed in the block.
  #
  # @param tenant [String] schema name
  # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
  # @yield The block that must be executed using the tenant connection
  def self.using(tenant, connection = ActiveRecord::Base.connection, &block)
    SchemaSwitcher.new(tenant, connection).run(&block)
  end
end
