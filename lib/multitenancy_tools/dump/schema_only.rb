require 'open3'

module MultitenancyTools
  module Dump
    class SchemaOnly
      def initialize(options)
        @schema = options.fetch(:schema)
        @database = options.fetch(:database)
        @host = options.fetch(:host, nil)
        @user = options.fetch(:username, nil)
      end

      def dump
        Open3.capture3(dump_args.shelljoin)
      end

      private

      def dump_args
        args = [
          'pg_dump',
          '--schema', @schema,
          '--schema-only',
          '--no-privileges',
          '--no-tablespaces',
          '--no-owner',
          '--dbname', @database,
        ]

        args << ['--host', @host] if @host.present?
        args << ['--username', @user] if @user.present?
        args.flatten
      end
    end
  end
end
