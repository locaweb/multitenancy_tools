module MultitenancyTools
  class SchemaCreator
    def initialize(schema, connection)
      @schema = schema
      @connection = connection
    end

    def create_from_file(file)
      quoted_schema_name = @connection.quote_table_name(@schema)

      Tenant.new(@schema, @connection).run do
        @connection.create_schema(quoted_schema_name)
        @connection.execute(File.read(file))
      end
    end
  end
end
