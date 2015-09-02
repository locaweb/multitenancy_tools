require 'spec_helper'

RSpec.describe MultitenancyTools::SchemaMigrator do
  def table_exists?(table)
    Db.connection.table_exists?(table)
  end

  def all_versions(schema)
    return [] unless table_exists?("#{schema}.schema_migrations")
    results = Db.connection.execute("SELECT version FROM #{schema}.schema_migrations")
    results.values.flatten
  end

  before { Db.connection.create_schema('schema1') }
  after { Db.connection.drop_schema('schema1') }

  subject { described_class.new('schema1', 'spec/fixtures/migrations') }

  describe '#migrate' do
    context 'schema_migrations table does not exist' do
      it 'creates the schema_migrations table' do
        expect { subject.migrate }
          .to change { table_exists?('schema1.schema_migrations') }
          .from(false).to(true)
      end

      it 'executes all migrations' do
        subject.migrate

        expect(table_exists?('schema1.a')).to be true
        expect(table_exists?('schema1.b')).to be true
        expect(table_exists?('schema1.c')).to be true
      end

      it 'inserts all versions in schema_migrations table' do
        expect { subject.migrate }
          .to change { all_versions('schema1') }
          .from([]).to(%w(20140228130000 20140228130001 20140228130002))
      end
    end

    context 'schema_migrations has not some migrations' do
      before do
        Db.connection.execute(<<-SQL)
          CREATE TABLE schema1.schema_migrations
            ("version" character varying NOT NULL);
          INSERT INTO schema1.schema_migrations
            VALUES (20140228130001);
        SQL
      end

      it 'executes missing migrations' do
        subject.migrate

        expect(table_exists?('schema1.a')).to be true
        expect(table_exists?('schema1.c')).to be true
        # the following is false because the migration that creates the "b"
        # table has the same timestamp that we inserted via SQL in previous
        # lines
        expect(table_exists?('schema1.b')).to be false
      end

      it 'inserts missing versions in schema_migrations' do
        expect { subject.migrate }
          .to change { all_versions('schema1') }
          .from(%w(20140228130001))
          .to(%w(20140228130001 20140228130000 20140228130002))
      end
    end
  end

  describe '#rollback' do
    context 'schema_migrations table does not exist' do
      it 'creates an empty schema_migrations table' do
        expect { subject.rollback }
          .to_not change { all_versions('schema1') }

        expect(table_exists?('schema1.schema_migrations')).to be true
      end
    end

    context 'schema_migrations has some migrations already executed' do
      before { subject.migrate }

      it 'removes the last version from schema_migrations' do
        expect { subject.rollback }
          .to change { all_versions('schema1') }
          .from(%w(20140228130000 20140228130001 20140228130002))
          .to(%w(20140228130000 20140228130001))
      end

      it 'executes the rollback procedure described in the latest migration' do
        subject.rollback

        expect(table_exists?('schema1.a')).to be true
        expect(table_exists?('schema1.b')).to be true
        expect(table_exists?('schema1.c')).to be false
      end
    end
  end
end
