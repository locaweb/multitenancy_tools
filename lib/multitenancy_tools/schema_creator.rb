module MultitenancyTools
  # {SchemaCreator} can be used to create a schema on a PostgreSQL database
  # using a SQL file as template (this template should be previously generated
  # using {SchemaDumper}).
  #
  # @example
  #   creator = MultitenancyTools::SchemaCreator.new('my_schema', ActiveRecord::Base.connection)
  #   creator.create_from_file('path/to/file.sql')
  class SchemaCreator
    # @param schema [String] schema name
    # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
    def initialize(schema, connection)
      @schema = schema
      @connection = connection
    end

    # @param file [String] path to a SQL file
    def create_from_file(file)
      quoted_schema_name = @connection.quote_table_name(@schema)

      Tenant.new(@schema, @connection).run do
        @connection.create_schema(quoted_schema_name)
        @connection.execute(File.read(file))
      end
    end
  end
end
