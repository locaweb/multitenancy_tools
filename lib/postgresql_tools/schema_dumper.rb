module PostgresqlTools
  class SchemaDumper
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

    protected

    def remove_creation_statements(dump)
      dump.gsub!(/CREATE SCHEMA .*;\n/, '')
      dump.gsub!(/SET search_path .*;\n/, '')
    end

    def remove_comments(dump)
      dump.gsub!(/^--(?:.*)\n+/, '')
    end

    def remove_duplicate_line_breaks(dump)
      dump.gsub!(/\n+/, "\n")
    end
  end
end
