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

      file.write(dump)
    end

    protected

    def remove_creation_statements(dump)
      dump.gsub!(/CREATE SCHEMA .*;\n/, '')
      dump.gsub!(/SET search_path .*;\n/, '')
    end
  end
end
