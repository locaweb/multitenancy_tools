require 'open3'

module MultitenancyTools
  # {SchemaDumper} can be used to generate SQL dumps of the structure of a
  # PostgreSQL schema.
  #
  # The generated dump DOES NOT contain:
  # * privilege statements (GRANT/REVOKE)
  # * tablespace assigments
  # * ownership information
  # * any table data
  #
  # {SchemaDumper} is suitable to create SQL templates for {SchemaCreator}.
  #
  # @example
  #   dumper = MultitenancyTools::SchemaDumper.new('my_db', 'my_schema')
  #   dumper.dump_to('path/to/file.sql')
  class SchemaDumper
    # @param database [String] database name
    # @param schema [String] schema name
    def initialize(database, schema)
      @database = database
      @schema = schema
    end

    # Generates a dump an writes it into a file.
    #
    # @param file [String] file path
    # @param mode [String] IO open mode
    def dump_to(file, mode: 'w')
      stdout, stderr, status = Open3.capture3(
        'pg_dump',
        '--schema', @schema,
        '--schema-only',
        '--no-privileges',
        '--no-tablespaces',
        '--no-owner',
        '--dbname', @database
      )

      unless status.success?
        raise PgDumpError.new(stderr)
      end

      File.open(file, mode) do |f|
        f.write DumpCleaner.new(stdout).clean
      end
    end
  end
end
