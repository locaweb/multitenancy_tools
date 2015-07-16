require 'open3'

module MultitenancyTools
  # {TableDumper} can be used to generate SQL dumps of the structure and,
  # unlike {SchemaDumper}, the data of a PostgreSQL table. It requires pg_dump.
  #
  # The generated dump DOES NOT contain:
  # * privilege statements (GRANT/REVOKE)
  # * tablespace assigments
  # * ownership information
  #
  # The dump will use INSERTs instead of COPY statements.
  #
  # @see http://www.postgresql.org/docs/9.3/static/app-pgdump.html
  #      pg_dump
  # @example
  #   dumper = MultitenancyTools::TableDumper.new('db name', 'schema name', 'table name')
  #   dumper.dump_to('path/to/file.sql')
  class TableDumper
    # @param database [String] database name
    # @param schema [String] schema name
    # @param table [String] table name
    def initialize(database, schema, table)
      @database = database
      @schema = schema
      @table = table
    end

    # Generates a dump an writes it into a file. Please see {IO.new} for open
    # modes.
    #
    # @see http://ruby-doc.org/core-2.2.2/IO.html#method-c-new-label-Open+Mode
    #      IO Open Modes
    # @param file [String] file path
    # @param mode [String] IO open mode
    def dump_to(file, mode: 'w')
      stdout, stderr, status = Open3.capture3(
        'pg_dump',
        '--table', "#{@schema}.#{@table}",
        '--data-only',
        '--no-privileges',
        '--no-tablespaces',
        '--no-owner',
        '--inserts',
        '--dbname', @database
      )

      fail(PgDumpError, stderr) unless status.success?

      File.open(file, mode) do |f|
        f.write DumpCleaner.new(stdout).clean
      end
    end
  end
end
