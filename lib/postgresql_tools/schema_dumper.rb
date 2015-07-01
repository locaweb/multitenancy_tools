module PostgresqlTools
  class SchemaDumper
    def initialize(database, schema)
      @database = database
      @schema = schema
    end

    def dump_to(file)
      io = IO.popen([
        'pg_dump',
        '--schema', @schema,
        '--schema-only',
        '--no-privileges',
        '--no-tablespaces',
        '--no-owner',
        '--dbname', @database
      ])
      IO.copy_stream(io, file)
    end
  end
end
