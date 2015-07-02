module PostgresqlTools
  module DumpCleaner
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
