module MultitenancyTools
  class Tenant
    def initialize(connection, schema)
      @connection = connection
      @schema = @connection.quote(schema)
    end

    def run(&block)
      original_path = @connection.schema_search_path
      @connection.schema_search_path = @schema
      yield
    ensure
      @connection.schema_search_path = original_path
    end
  end
end
