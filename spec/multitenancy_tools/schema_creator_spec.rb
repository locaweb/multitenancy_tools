require 'spec_helper'
require 'support/db'
require 'tempfile'

RSpec.describe MultitenancyTools::SchemaCreator do
  before(:all) do
    Db.setup
    Db.connect
  end

  after(:all) do
    Db.teardown
  end

  let(:schema_name) { 'schema1' }

  subject do
    described_class.new(schema_name, Db.connection)
  end

  describe '#from_sql' do
    before do
      subject.from_sql('spec/fixtures/dump.sql')
    end

    after do
      Db.connection.execute("DROP SCHEMA IF EXISTS #{schema_name} CASCADE")
    end

    it 'executes the sql file' do
      expect(Db.connection.table_exists?("#{schema_name}.posts")).to be true
    end

    it 'sets connection search path back to its original value' do
      expect(Db.connection.schema_search_path).to eql('"$user",public')
    end
  end
end
