module MultitenancyTools
  class SchemaCreator
    def initialize(schema, connection)
      @schema = schema
      @connection = connection
    end

    def from_sql(file)
      quoted_schema_name = @connection.quote_table_name(@schema)

      Tenant.new(@connection, @schema).run do
        @connection.create_schema(quoted_schema_name)
        @connection.execute(File.read(file))
      end
    end
  end
end
