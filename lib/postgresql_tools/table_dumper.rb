module PostgresqlTools
  class TableDumper
    include DumpCleaner

    def initialize(database, schema, table)
      @database = database
      @schema = schema
      @table = table
    end

    def dump_to(file)
      dump = IO.popen([
        'pg_dump',
        '--table', "#{@schema}.#{@table}",
        '--data-only',
        '--no-privileges',
        '--no-tablespaces',
        '--no-owner',
        '--inserts',
        '--dbname', @database
      ]).read

      remove_creation_statements(dump)
      remove_comments(dump)
      remove_duplicate_line_breaks(dump)

      file.write(dump)
    end
  end
end
