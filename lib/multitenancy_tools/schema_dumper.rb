module MultitenancyTools
  class SchemaDumper
    include DumpCleaner

    def initialize(database, schema)
      @database = database
      @schema = schema
    end

    def dump_to(file)
      dump = IO.popen([
        'pg_dump',
        '--schema', @schema,
        '--schema-only',
        '--no-privileges',
        '--no-tablespaces',
        '--no-owner',
        '--dbname', @database
      ]).read

      remove_creation_statements(dump)
      remove_comments(dump)
      remove_duplicate_line_breaks(dump)

      file.write(dump)
    end
  end
end
