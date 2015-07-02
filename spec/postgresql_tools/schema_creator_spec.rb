require 'spec_helper'
require 'db_helper'
require 'tempfile'

RSpec.describe PostgresqlTools::SchemaCreator do
  before(:all) do
    DbHelper.create_db
    DbHelper.connect_to_test_db
  end

  after(:all) do
    DbHelper.drop_db
  end

  let(:schema_name) { 'schema1' }

  subject do
    described_class.new(schema_name, DbHelper.connection)
  end

  describe '#from_sql' do
    before do
      subject.from_sql('spec/fixtures/dump.sql')
    end

    after do
      DbHelper.connection
        .execute("DROP SCHEMA IF EXISTS #{schema_name} CASCADE")
    end

    it 'executes the sql file' do
      expect(DbHelper.table_exists?(schema_name, 'posts')).to be true
    end

    it 'sets connection search path back to its original value' do
      expect(DbHelper.connection.schema_search_path).to eql('"$user",public')
    end
  end
end
