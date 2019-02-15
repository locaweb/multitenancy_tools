require 'open3'

module MultitenancyTools
  module Dump
    class DataOnly
      def initialize(options)
        @schema = options.fetch(:schema)
        @db = options.fetch(:database)
        @host = options.fetch(:host, nil)
        @user = options.fetch(:username, nil)
        @table = options.fetch(:table)
      end

      def dump
        Open3.capture3(dump_args.shelljoin)
      end

      private

      def dump_args
        args = [
          'pg_dump',
          '--table', "#{@schema}.#{@table}",
          '--no-privileges',
          '--no-tablespaces',
          '--no-owner',
          '--dbname', @db,
          '--data-only',
          '--inserts'
        ]

        args << ['--host', @host] if @host.present?
        args << ['--username', @user] if @user.present?
        args.flatten
      end
    end
  end
end
