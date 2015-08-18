module MultitenancyTools
  # {FunctionsDumper} can be used to generate a SQL dump of all functions that
  # are present on a PostgreSQL schema.
  #
  # @example
  #   dumper = MultitenancyTools::FunctionsDumper.new('schema name')
  #   dumper.dump_to('path/to/file.sql')
  class FunctionsDumper
    # @param schema [String] schema name
    # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
    def initialize(schema, connection = ActiveRecord::Base.connection)
      @connection = connection
      @schema = @connection.quote(schema)
    end

    # Generates a dump and writes it into a file. Please see {IO.new} for open
    # modes.
    #
    # @see http://ruby-doc.org/core-2.2.2/IO.html#method-c-new-label-Open+Mode
    #      IO Open Modes
    # @param file [String] file path
    # @param mode [String] IO open mode
    def dump_to(file, mode: 'w')
      results = @connection.execute(<<-SQL)
        SELECT
          trim(trailing e' \n' from pg_get_functiondef(f.oid)) || ';\n'
          AS definition
        FROM pg_catalog.pg_proc f
        INNER JOIN pg_catalog.pg_namespace n ON (f.pronamespace = n.oid)
        WHERE n.nspname = #{@schema};
      SQL

      File.open(file, mode) do |f|
        results.each do |result|
          f.write result['definition']
        end
      end
    end
  end
end
