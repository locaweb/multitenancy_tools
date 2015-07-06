require 'spec_helper'

RSpec.describe MultitenancyTools::DumpCleaner do
  let(:sql) do
    <<-SQL
-- this is a comment


CREATE SCHEMA foo_bar;
SET search_path = foo_bar;
SET statement_timeout = 0;
SET lock_timeout = 0;
CREATE TABLE posts (
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
    subject { described_class.new(sql).clean }

    it { expect(subject).to eql(expected_sql) }

    it 'does not change original string' do
      expect { subject }.to_not change { sql }
    end

    it 'removes create schema statements' do
      expect(subject).to_not match(/CREATE SCHEMA/)
    end

    it 'removes set search_path statements' do
      expect(subject).to_not match(/SET search_path/)
    end

    it 'removes set statement_timeout' do
      expect(subject).to_not match(/SET statement_timeout/)
    end

    it 'removes set lock_timeout' do
      expect(subject).to_not match(/SET lock_timeout/)
    end

    it 'removes comments' do
      expect(subject).to_not match(/--/)
    end

    it 'removes duplicate line breaks' do
      expect(subject).to_not match(/\n\n/)
    end
  end
end
