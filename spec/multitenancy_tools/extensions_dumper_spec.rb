require 'spec_helper'

RSpec.describe MultitenancyTools::ExtensionsDumper do
  before(:all) do
    Db.connection.execute(<<-SQL)
      DROP SCHEMA IF EXISTS schema1 CASCADE;
      DROP EXTENSION IF EXISTS hstore;
      CREATE SCHEMA schema1;
      CREATE EXTENSION hstore;
    SQL
  end

  describe '#dump_to' do
    subject { described_class.new(Db.connection) }

    around do |example|
      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do
          example.run
        end
      end
    end

    before do
      subject.dump_to('dump.sql')
    end

    let(:file) { File.read('dump.sql') }
    let(:dump) { File.join(__dir__, '../fixtures/extensions_dump.sql') }

    it 'generates a SQL dump with all extensions of the schema' do
      expect(file).to eql(File.read(dump))
    end

    it 'does not include create table statements' do
      expect(file).to_not match(/create table/i)
    end

    it 'does not include create schema statements' do
      expect(file).to_not match(/create schema/i)
    end

    it 'does not include copy statements' do
      expect(file).to_not match(/copy/i)
    end
  end
end
