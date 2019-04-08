require 'spec_helper'

RSpec.describe MultitenancyTools::SchemaDumper do
  before do
    Db.connection.execute(<<-SQL)
      DROP SCHEMA IF EXISTS schema1 CASCADE;
      CREATE SCHEMA schema1;
      CREATE TABLE schema1.posts (
          id SERIAL NOT NULL PRIMARY KEY,
          title text,
          body text
      );
      CREATE TABLE schema1.schema_migrations (
          version character varying NOT NULL
      );
      CREATE UNIQUE INDEX unique_schema_migrations
          ON schema1.schema_migrations USING btree (version);
    SQL
  end

  describe '#dump_to' do
    subject do
      described_class.new(Db.name,
                          'schema1',
                          { host: Db.host, username: Db.username })
    end

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        end
      end
    end

    context 'schema exists' do
      before do
        subject.dump_to('dump.sql')
      end

      let(:file) { File.read('dump.sql') }

      it 'contains create table statements' do
        expect(file).to match(/CREATE TABLE posts/)
      end

      it 'does not include table data' do
        expect(file).to_not match(/COPY posts/)
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

    context 'schema does not exist' do
      subject do
        described_class.new(Db.name,
                            'schema2',
                            { host: Db.host, username: Db.username })
      end

      it 'raises an error' do
        expect do
          subject.dump_to('dump.sql')
        end.to raise_error(MultitenancyTools::PgDumpError,
                           /No matching schemas were found/i)
      end
    end

    context 'changing IO mode' do
      it 'opens the file using the passed IO mode' do
        expect(File).to receive(:open).with(kind_of(String), 'a')
        subject.dump_to('dump.sql', mode: 'a')
      end
    end

    context 'changing server host' do
      it 'connects to a different host when host argument is provided' do
        file = Tempfile.new('lalala')
        expect do
          described_class.new(Db.name, 'schema1', { host: 'another_host' }).dump_to(file)
        end.to raise_error MultitenancyTools::PgDumpError, /could not translate host name/
      end
    end

    context 'changing database username' do
      it 'connects using a different user when username is provided' do
        file = Tempfile.new('lalala')
        expect do
          described_class.new(Db.name, 'schema1', { host: Db.host, username: 'richard' }).dump_to(file)
        end.to raise_error MultitenancyTools::PgDumpError, /role "richard" does not exist/
      end
    end
  end
end
