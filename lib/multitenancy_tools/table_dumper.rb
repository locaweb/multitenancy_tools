module MultitenancyTools
  class TableDumper
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

      file.write(DumpCleaner.new(dump).clean)
    end
  end
end
