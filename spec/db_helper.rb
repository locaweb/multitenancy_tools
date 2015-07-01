require 'active_record'

class DbHelper
  class << self
    def config
      @config ||= YAML.load_file('spec/database.yml')
    end

    def db_name
      config['database']
    end

    def create_db
      connect_to_root
      connection.create_database(db_name, config)
    end

    def drop_db
      connect_to_root
      connection.drop_database(db_name)
    end

    def connection
      ActiveRecord::Base.connection
    end

    def connect_to_root
      ActiveRecord::Base.establish_connection(
        config.merge('database' => 'postgres'))
    end

    def connect_to_test_db
      ActiveRecord::Base.establish_connection(config)
    end
  end
end
