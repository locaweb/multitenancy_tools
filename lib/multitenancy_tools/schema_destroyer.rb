module MultitenancyTools
  # {SchemaDestroyer} can be used to destroy a PostgreSQL schema.
  #
  # @example
  #   destroyer = MultitenancyTools::SchemaDestroyer.new('schema name')
  #   destroyer.destroy
  class SchemaDestroyer
    # @param schema [String] schema name
    # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
    def initialize(schema, connection = ActiveRecord::Base.connection)
      @connection = connection
      @schema = @connection.quote_table_name(schema)
    end

    # Drops the schema.
    def destroy
      @connection.drop_schema(@schema)
    end
  end
end
