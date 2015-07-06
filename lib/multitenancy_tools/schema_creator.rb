module MultitenancyTools
  class SchemaCreator
    def initialize(schema, connection)
      @schema = schema
      @connection = connection
    end

    def from_sql(file)
      original_path = @connection.schema_search_path
      @connection.execute("CREATE SCHEMA IF NOT EXISTS #{@schema}")
      @connection.schema_search_path = @schema
      @connection.execute(File.read(file))
    ensure
      @connection.schema_search_path = original_path
    end
  end
end
