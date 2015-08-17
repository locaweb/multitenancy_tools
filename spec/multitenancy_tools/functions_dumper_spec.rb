require 'spec_helper'

RSpec.describe MultitenancyTools::FunctionsDumper do
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
      CREATE FUNCTION schema1.cast_to_date(text) RETURNS date
          LANGUAGE plpgsql IMMUTABLE
          AS $_$
              BEGIN
                  RETURN CAST($1 AS DATE); EXCEPTION
              WHEN data_exception THEN
                  RETURN NULL ;
              END ; $_$;
    SQL
  end

  describe '#dump_to' do
    subject do
      described_class.new('schema1', Db.connection)
    end

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

    it 'generates a SQL dump with all functions' do
      dump_file = File.expand_path('../../fixtures/functions_dump.sql', __FILE__)
      expect(file).to eql(File.read(dump_file))
    end
  end
end
