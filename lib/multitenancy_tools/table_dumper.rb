require 'open3'

module MultitenancyTools
  class TableDumper
    def initialize(database, schema, table)
      @database = database
      @schema = schema
      @table = table
    end

    def dump_to(file)
      stdout, _, _ = Open3.capture3(
        'pg_dump',
        '--table', "#{@schema}.#{@table}",
        '--data-only',
        '--no-privileges',
        '--no-tablespaces',
        '--no-owner',
        '--inserts',
        '--dbname', @database
      )

      file.write(DumpCleaner.new(stdout).clean)
    end
  end
end
