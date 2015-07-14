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

    context 'create_schema is false' do
      it 'raises an error when schema does not exist' do
        expect do
          subject.create_from_file(sql_path, create_schema: false)
        end.to raise_error(/no schema has been selected to create in/)
      end

      it 'executes the sql file successfully when the schema exist' do
        Db.connection.execute("CREATE SCHEMA #{schema_name}")
        subject.create_from_file(sql_path, create_schema: false)
        expect(Db.connection.table_exists?("#{schema_name}.posts")).to be true
      end
    end
  end
end
