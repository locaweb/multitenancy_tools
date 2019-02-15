require 'spec_helper'
require 'tempfile'

RSpec.describe MultitenancyTools::TableDumper do
  before do
    Db.connection.execute(<<-SQL)
      DROP SCHEMA IF EXISTS schema1 CASCADE;
      CREATE SCHEMA schema1;
      CREATE TABLE schema1.posts (
          id SERIAL NOT NULL PRIMARY KEY,
          title text,
          body text
      );
      INSERT INTO schema1.posts (title, body)
      VALUES ('foo bar baz', 'post content');
    SQL
  end

  describe '#dump_to' do
    subject do
      described_class.new(Db.name,
                          'schema1',
                          'posts',
                          { host: Db.host, username: Db.username })
    end

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        end
      end
    end

    context 'table exists' do
      before do
        subject.dump_to('dump.sql')
      end

      let(:file) { File.read('dump.sql') }

      it 'includes table data' do
        expect(file).to match(/INSERT INTO/)
      end

      it 'does not contain create table statements' do
        expect(file).to_not match(/CREATE TABLE/)
      end

      it 'does not dump privileges' do
        expect(file).to_not match(/GRANT|REVOKE/)
      end

      it 'does not dump tablespace assignments' do
        expect(file).to_not match(/default_tablespace/)
      end

      it 'does not include object ownership' do
        expect(file).to_not match(/OWNER TO/)
      end

      it 'does not include create schema statements' do
        expect(file).to_not match(/CREATE SCHEMA/)
      end

      it 'does not set search_path' do
        expect(file).to_not match(/SET search_path/)
      end

      it 'does not set statement_timeout' do
        expect(file).to_not match(/SET statement_timeout/)
      end

      it 'does not set lock_timeout' do
        expect(file).to_not match(/SET lock_timeout/)
      end

      it 'does not include any comments' do
        expect(file).to_not match(/--/)
      end

      it 'removes duplicate line breaks' do
        expect(file).to_not match(/\n\n/)
      end
    end

    context 'table does not exist' do
      subject do
        described_class.new(Db.name,
                            'schema1',
                            'foos',
                            { host: Db.host, username: Db.username })
      end

      it 'raises an error' do
        expect do
          subject.dump_to('dump.sql')
        end.to raise_error(MultitenancyTools::PgDumpError,
                           /No matching tables were found/)
      end
    end

    context 'changing IO mode' do
      it 'opens the file using the passed IO mode' do
        expect(File).to receive(:open).with(kind_of(String), 'a')
        subject.dump_to('dump.sql', mode: 'a')
      end
    end
  end
end
