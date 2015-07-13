require 'spec_helper'
require 'tempfile'

RSpec.describe MultitenancyTools::TableDumper do
  before(:all) do
    Db.connection.create_schema('schema1')
    Db.connection.schema_search_path = 'schema1'

    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(version: 20140407140000) do
        create_table 'posts', force: true do |t|
          t.text 'title'
          t.text 'body'
        end
      end
    end

    Db.connection.execute(<<-SQL)
      INSERT INTO posts (title, body)
      VALUES ('foo bar baz', 'post content');
    SQL
  end

  subject do
    described_class.new(Db.name, 'schema1', 'posts')
  end

  describe '#dump_to' do
    let(:io) { StringIO.new }

    context 'table exists' do
      before do
        subject.dump_to(io)
        io.rewind
      end

      it 'generates a SQL dump of the schema' do
        expect(io.read).to eql(File.read('spec/fixtures/table_dump.sql'))
      end

      it 'includes table data' do
        expect(io.read).to match(/INSERT INTO/)
      end

      it 'does not contain create table statements' do
        expect(io.read).to_not match(/CREATE TABLE/)
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

      it 'does not include create schema statements' do
        expect(io.read).to_not match(/CREATE SCHEMA/)
      end

      it 'does not set search_path' do
        expect(io.read).to_not match(/SET search_path/)
      end

      it 'does not set statement_timeout' do
        expect(io.read).to_not match(/SET statement_timeout/)
      end

      it 'does not set lock_timeout' do
        expect(io.read).to_not match(/SET lock_timeout/)
      end

      it 'does not include any comments' do
        expect(io.read).to_not match(/--/)
      end

      it 'removes duplicate line breaks' do
        expect(io.read).to_not match(/\n\n/)
      end
    end

    context 'table does not exist' do
      subject do
        described_class.new(Db.name, 'schema1', 'foos')
      end

      it 'raises an error' do
        expect do
          subject.dump_to(io)
        end.to raise_error(MultitenancyTools::PgDumpError,
                           /No matching tables were found/)
      end
    end
  end
end
