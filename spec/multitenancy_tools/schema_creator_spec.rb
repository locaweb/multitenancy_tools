require 'spec_helper'
require 'tempfile'

RSpec.describe MultitenancyTools::SchemaCreator do
  let(:schema_name) { 'schema1' }
  let(:sql_path) { 'spec/fixtures/schema_dump.sql' }

  subject do
    described_class.new(schema_name, Db.connection)
  end

  describe '#create_from_file' do
    after do
      Db.connection.execute("DROP SCHEMA IF EXISTS #{schema_name} CASCADE")
    end

    it 'executes the sql file' do
      subject.create_from_file(sql_path)
      expect(Db.connection.table_exists?("#{schema_name}.posts")).to be true
    end

    it 'sets connection search path back to its original value' do
      subject.create_from_file(sql_path)
      expect(Db.connection.schema_search_path).to eql('"$user",public')
    end
  end
end
