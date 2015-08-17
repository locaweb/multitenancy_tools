require 'spec_helper'

RSpec.describe MultitenancyTools::FunctionsDumper do
  before(:all) do
    Db.connection.execute(<<-SQL)
      DROP SCHEMA IF EXISTS schema1 CASCADE;
      DROP SCHEMA IF EXISTS schema2 CASCADE;
      CREATE SCHEMA schema1;
      CREATE SCHEMA schema2;
      CREATE FUNCTION schema1.increment(i integer) RETURNS integer AS $$
          BEGIN
              RETURN i + 1;
          END;
      $$ LANGUAGE plpgsql;
      CREATE FUNCTION schema1.decrement(i integer) RETURNS integer AS $$
          BEGIN
              RETURN i - 1;
          END;
      $$ LANGUAGE plpgsql;
      CREATE FUNCTION schema2.function_for_schema2(i integer) RETURNS integer AS $$
          BEGIN
              RETURN i + 1;
          END;
      $$ LANGUAGE plpgsql;
    SQL
  end

  describe '#dump_to' do
    subject { described_class.new('schema1', Db.connection) }

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

    it 'generates a SQL dump with all functions of the schema' do
      dump_file = File.expand_path('../../fixtures/functions_dump.sql', __FILE__)
      expect(file).to eql(File.read(dump_file))
    end

    it 'does not include functions from other schemas' do
      expect(file).to_not match(/schema2/)
      expect(file).to_not match(/function_for_schema2/)
    end
  end
end
