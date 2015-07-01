require 'spec_helper'
require 'db_helper'
require 'tempfile'

RSpec.describe PostgresqlTools::SchemaDumper do
  before(:all) do
    DbHelper.create_db
    DbHelper.connect_to_test_db

    DbHelper.connection.create_schema('schema1')
    DbHelper.connection.schema_search_path = 'schema1'

    ActiveRecord::Schema.define(version: 20140407140000) do
      create_table 'posts', force: true do |t|
        t.text 'title'
        t.text 'body'
      end
    end
  end

  after(:all) do
    DbHelper.drop_db
  end

  subject do
    described_class.new(DbHelper.db_name, 'schema1')
  end

  describe '#dump_to' do
    let(:io) { StringIO.new }

    before do
      subject.dump_to(io)
      io.rewind
    end

    it 'generates a SQL dump of the schema' do
      expect(io.read).to eql(File.read('spec/fixtures/dump.sql'))
    end

    it 'contains create table statements' do
      expect(io.read).to match(/CREATE TABLE posts/)
    end

    it 'does not include table data' do
      expect(io.read).to_not match(/COPY posts/)
    end

    it 'does not dump privileges' do
      expect(io.read).to_not match(/GRANT|REVOKE/)
    end

    it 'does not dump tablespace assignments' do
      expect(io.read).to_not match(/default_tablespace/)
    end

    it 'does not include object ownership' do
      expect(io.read).to_not match(/OWNER TO/)
    end
  end
end
