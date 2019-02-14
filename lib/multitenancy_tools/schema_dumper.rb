require 'open3'

module MultitenancyTools
  # {SchemaDumper} can be used to generate SQL dumps of the structure of a
  # PostgreSQL schema. It requires pg_dump.
  #
  # The generated dump DOES NOT contain:
  # * privilege statements (GRANT/REVOKE)
  # * tablespace assigments
  # * ownership information
  # * any table data
  # * extensions (CREATE EXTENSION)
  #
  # {SchemaDumper} is suitable to create SQL templates for {SchemaCreator}.
  #
  # @see http://www.postgresql.org/docs/9.3/static/app-pgdump.html
  #      pg_dump
  # @example
  #   dumper = MultitenancyTools::SchemaDumper.new('my_db', 'my_schema')
  #   dumper.dump_to('path/to/file.sql')
  class SchemaDumper
    # @param database [String] database name
    # @param schema [String] schema name
    def initialize(database, schema, options = {})
      @database = database
      @schema = schema
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
      stdout, stderr, status = Dump::SchemaOnly.new(
        schema: @schema,
        host: @host,
        username: @username,
        database: @database
      ).dump

      fail(PgDumpError, stderr) unless status.success?

      File.open(file, mode) do |f|
        f.write DumpCleaner.new(stdout, @schema).clean
      end
    end
  end
end
