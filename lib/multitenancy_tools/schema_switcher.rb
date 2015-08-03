module MultitenancyTools
  # {SchemaSwitcher} can be used to switch between PostgreSQL schemas on a
  # connection. It uses PostgreSQL search_path to achieve this functionality.
  class SchemaSwitcher
    # @param schema [String] schema name
    # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
    def initialize(schema, connection = ActiveRecord::Base.connection)
      @connection = connection
      @schema = @connection.quote(schema)
    end

    # This sets the connection search_path to use only the current schema,
    # yields the block and then change search_path back to its previous value.
    def run(&block)
      original_path = @connection.schema_search_path
      set_path_if_required(@schema)
      yield
    ensure
      set_path_if_required(original_path)
    end

    protected

    # Change search_path only if the current search_path is different. This
    # avoids unnecessary queries to change the connection search_path when it
    # already has the desired value.
    def set_path_if_required(schema)
      return if @connection.schema_search_path == schema
      @connection.schema_search_path = schema
    end
  end
end
