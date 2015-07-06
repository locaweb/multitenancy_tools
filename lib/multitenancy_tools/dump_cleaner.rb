module MultitenancyTools
  class DumpCleaner
    def initialize(sql)
      @sql = sql.dup
    end

    def clean
      @sql.gsub!(/CREATE SCHEMA .*;\n/, '')
      @sql.gsub!(/SET search_path .*;\n/, '')
      @sql.gsub!(/SET statement_timeout .*;\n/, '')
      @sql.gsub!(/SET lock_timeout .*;\n/, '')
      @sql.gsub!(/^--(?:.*)\n+/, '')
      @sql.gsub!(/\n+/, "\n")
      @sql
    end
  end
end
