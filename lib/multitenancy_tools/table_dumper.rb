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
    def initialize(database, schema, table, options = {})
      @database = database
      @schema = schema
      @table = table
      @host = options.fetch(:host, '')
      @username = options.fetch(:username, '')
    end

    # Generates a dump an writes it into a file. Please see {IO.new} for open
    # modes.
    #
    # @see http://ruby-doc.org/core-2.2.2/IO.html#method-c-new-label-Open+Mode
    #      IO Open Modes
    # @param file [String] file path
    # @param mode [String] IO open mode
    def dump_to(file, mode: 'w')
      stdout, stderr, status = Dump::DataOnly.new(
        table: @table,
        schema: @schema,
        database: @database,
        host: @host,
        username: @username
      ).dump

      fail(PgDumpError, stderr) unless status.success?

      File.open(file, mode) do |f|
        f.write DumpCleaner.new(stdout, @schema).clean
      end
    end
  end
end
