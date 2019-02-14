require 'spec_helper'

RSpec.describe MultitenancyTools::DumpCleaner do
  let(:sql) do
    <<-SQL
-- this is a comment


CREATE SCHEMA foo_bar;
SET search_path = foo_bar;
SET statement_timeout = 0;
SET lock_timeout = 0;
CREATE TABLE schema.posts (
    id integer NOT NULL,
    title text,
    body text
);
    SQL
  end

  let(:expected_sql) do
    <<-SQL
CREATE TABLE posts (
    id integer NOT NULL,
    title text,
    body text
);
    SQL
  end

  describe '#clean' do
    it 'cleans generated sql' do
      output = described_class.new(sql, 'schema').clean

      expect(output).to eql(expected_sql)
    end

    it 'does not change original string' do
      expect { described_class.new(sql, 'schema').clean }
        .to_not change { sql }
    end

    it 'removes create schema statements' do
      output = described_class.new(sql, 'schema').clean
      expect(output).to_not match(/CREATE SCHEMA/)
    end

    it 'removes set search_path statements' do
      output = described_class.new(sql, 'schema').clean
      expect(output).to_not match(/SET search_path/)
    end

    it 'removes set statement_timeout' do
      output = described_class.new(sql, 'schema').clean
      expect(output).to_not match(/SET statement_timeout/)
    end

    it 'removes set lock_timeout' do
      output = described_class.new(sql, 'schema').clean
      expect(output).to_not match(/SET lock_timeout/)
    end

    it 'removes comments' do
      output = described_class.new(sql, 'schema').clean
      expect(output).to_not match(/--/)
    end

    it 'removes duplicate line breaks' do
      output = described_class.new(sql, 'schema').clean
      expect(output).to_not match(/\n\n/)
    end

    it 'removes schema names on table' do
      output = described_class.new(sql, 'schema').clean
      expect(output).to_not match(/schema\.posts/)
    end

    context 'when no option is passed' do
      it 'keeps the schema names' do
        output = described_class.new(sql).clean
        expect(output).to match(/schema\.posts/)
      end
    end
  end
end
