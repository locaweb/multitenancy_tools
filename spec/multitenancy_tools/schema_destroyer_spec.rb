require 'spec_helper'

RSpec.describe MultitenancyTools::SchemaDestroyer do
  subject { described_class.new('schema1', Db.connection) }

  describe '#destroy' do
    before do
      Db.connection.execute(<<-SQL)
        CREATE SCHEMA schema1;
        CREATE TABLE schema1.test (
          foo text
        );
      SQL
    end

    it 'drops the schema' do
      expect(Db.connection.schema_exists?('schema1')).to be true
      subject.destroy
      expect(Db.connection.schema_exists?('schema1')).to be false
    end
  end
end
