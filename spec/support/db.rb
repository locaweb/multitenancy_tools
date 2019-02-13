require 'active_record'

module Db
  module_function

  def host
    config['host']
  end

  def username
    config['username']
  end

  def config
    @config ||= YAML.load_file('spec/database.yml')
  end

  def name
    config['database']
  end

  def setup
    connect_to_root
    connection.create_database(name, config)
  end

  def teardown
    connect_to_root
    connection.drop_database(name)
  end

  def connection
    ActiveRecord::Base.connection
  end

  def connect_to_root
    ActiveRecord::Base.establish_connection(
      config.merge('database' => 'postgres'))
  end

  def connect
    ActiveRecord::Base.establish_connection(config)
  end
end
