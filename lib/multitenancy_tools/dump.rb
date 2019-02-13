require 'open3'

module MultitenancyTools
  class Dump
    class << self
      def call(options={})
        @schema = options.fetch(:schema)
        @database = options.fetch(:database)
        @host = options.fetch(:host, nil)
        @username = options.fetch(:username, nil)

        Open3.capture3(args)
      end

      private

      def args
        args = default_args
        args << ['--host', @host] if @host
        args << ['--username', @username] if @username

        args.join(' ')
      end

      def default_args
        ['pg_dump',
         '--schema', @schema,
         '--schema-only',
         '--no-privileges',
         '--no-tablespaces',
         '--no-owner',
         '--dbname', @database]
      end
    end
  end
end
