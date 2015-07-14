module MultitenancyTools
  class SchemaCreator
    def initialize(schema, connection)
      @schema = schema
      @connection = connection
    end

    def create_from_file(file, create_schema: true)
      quoted_schema_name = @connection.quote_table_name(@schema)

      Tenant.new(@connection, @schema).run do
        @connection.create_schema(quoted_schema_name) if create_schema
        @connection.execute(File.read(file))
      end
    end
  end
end
