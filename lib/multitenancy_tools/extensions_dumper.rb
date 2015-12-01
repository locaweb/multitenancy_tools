module MultitenancyTools
  # {ExtensionsDumper} can be used to generate a SQL dump of all extensions that
  # are enabled on a PostgreSQL database.
  #
  # @example
  #   dumper = MultitenancyTools::ExtensionsDumper.new
  #   dumper.dump_to('path/to/file.sql')
  class ExtensionsDumper
    EXTENSION_SQL = <<-'SQL'.freeze
      SELECT extname, nspname FROM pg_extension
      JOIN pg_namespace n ON (extnamespace = n.oid)
    SQL

    CREATE_EXTENSION_SQL = "CREATE EXTENSION IF NOT EXITS '%s' WITH SCHEMA %s;\n".freeze

    # @param connection [ActiveRecord::ConnectionAdapters::PostgreSQLAdapter] connection adapter
    def initialize(connection = ActiveRecord::Base.connection)
      @connection = connection
    end

    # Generates a dump and writes it into a file. Please see {IO.new} for open
    # modes.
    #
    # @see http://ruby-doc.org/core-2.2.2/IO.html#method-c-new-label-Open+Mode
    #      IO Open Modes
    # @param file [String] file path
    # @param mode [String] IO open mode
    def dump_to(file, mode: 'w')
      results = @connection.execute(EXTENSION_SQL)

      File.open(file, mode) do |f|
        results.each do |result|
          name = result.fetch('extname')
          schema = result.fetch('nspname')

          f.write(format(CREATE_EXTENSION_SQL, name, schema))
        end
      end
    end
  end
end
