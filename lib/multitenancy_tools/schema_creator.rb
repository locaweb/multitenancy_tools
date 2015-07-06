module MultitenancyTools
  class SchemaCreator
    def initialize(schema, connection)
      @schema = schema
      @connection = connection
    end

    def from_sql(file)
      original_path = @connection.schema_search_path

      quoted_for_search_path = @connection.quote(@schema)
      quoted_schema_name = @connection.quote_table_name(@schema)

      @connection.execute("CREATE SCHEMA IF NOT EXISTS #{quoted_schema_name}")
      @connection.schema_search_path = quoted_for_search_path
      @connection.execute(File.read(file))
    ensure
      @connection.schema_search_path = original_path
    end
  end
end
