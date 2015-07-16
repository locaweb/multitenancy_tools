module MultitenancyTools
  # {SchemaSwitcher} can be used to switch between PostgreSQL schemas on a
  # connection. It uses PostgreSQL search_path to achieve this functionality.
  class SchemaSwitcher
    # @param schema [String] schema name
    # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
    def initialize(schema, connection)
      @connection = connection
      @schema = @connection.quote(schema)
    end

    # This sets the connection search_path to use only the current schema,
    # yields the block and then change search_path back to its previous value.
    def run(&block)
      original_path = @connection.schema_search_path
      @connection.schema_search_path = @schema
      yield
    ensure
      @connection.schema_search_path = original_path
    end
  end
end
