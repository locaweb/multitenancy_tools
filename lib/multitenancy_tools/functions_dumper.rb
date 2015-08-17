module MultitenancyTools
  class FunctionsDumper
    def initialize(schema, connection = ActiveRecord::Base.connection)
      @connection = connection
      @schema = @connection.quote(schema)
    end

    def dump_to(file, mode: 'w')
      query = <<-SQL
        SELECT pg_get_functiondef(f.oid) as definition
        FROM pg_catalog.pg_proc f
        INNER JOIN pg_catalog.pg_namespace n ON (f.pronamespace = n.oid)
        WHERE n.nspname = #{@schema};
      SQL

      results = @connection.execute(query)

      File.open(file, mode) do |f|
        results.each do |result|
          f.write result['definition']
        end
      end
    end
  end
end
