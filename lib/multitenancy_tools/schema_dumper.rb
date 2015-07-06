module MultitenancyTools
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

      file.write(DumpCleaner.new(dump).clean)
    end
  end
end
