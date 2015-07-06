require 'open3'

module MultitenancyTools
  class SchemaDumper
    def initialize(database, schema)
      @database = database
      @schema = schema
    end

    def dump_to(file)
      stdout, _, _ = Open3.capture3(
        'pg_dump',
        '--schema', @schema,
        '--schema-only',
        '--no-privileges',
        '--no-tablespaces',
        '--no-owner',
        '--dbname', @database
      )

      file.write(DumpCleaner.new(stdout).clean)
    end
  end
end
