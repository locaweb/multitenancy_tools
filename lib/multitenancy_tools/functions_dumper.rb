module MultitenancyTools
  # {FunctionsDumper} can be used to generate a SQL dump of all functions that
  # are present on a PostgreSQL schema.
  #
  # Please note that C functions are not included in the dump.
  #
  # @example
  #   dumper = MultitenancyTools::FunctionsDumper.new('schema name')
  #   dumper.dump_to('path/to/file.sql')
  class FunctionsDumper
    FUNCTIONS_SQL = <<-SQL.freeze
      SELECT
        trim(trailing e' \n' from pg_get_functiondef(f.oid)) || ';'
        AS definition
      FROM pg_catalog.pg_proc f
      JOIN pg_catalog.pg_namespace n ON (f.pronamespace = n.oid)
      JOIN pg_catalog.pg_language l ON (f.prolang = l.oid)
      WHERE n.nspname = %s
      AND l.lanname != 'c';
    SQL

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
      results = @connection.execute(format(FUNCTIONS_SQL, @schema))

      File.open(file, mode) do |f|
        results.each do |result|
          f.puts result.fetch('definition')
        end
      end
    end
  end
end
