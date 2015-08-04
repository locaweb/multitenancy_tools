require 'spec_helper'

RSpec.describe MultitenancyTools do
  describe '.create' do
    it 'creates a new schema using the SQL template' do
      creator = double

      expect(MultitenancyTools::SchemaCreator)
        .to receive(:new)
        .with('foobar', ActiveRecord::Base.connection) { creator }
      expect(creator).to receive(:create_from_file).with('path/to/file.sql')

      subject.create('foobar', 'path/to/file.sql')
    end
  end

  describe '.destroy' do
    it 'drops the schema from the database' do
      destroyer = double

      expect(MultitenancyTools::SchemaDestroyer)
        .to receive(:new)
        .with('foobar', ActiveRecord::Base.connection) { destroyer }
      expect(destroyer).to receive(:destroy)

      subject.destroy('foobar')
    end
  end

  describe '.using' do
    it 'routes all queries to the passed tenant' do
      switcher = double
      proc = Proc.new {}

      expect(MultitenancyTools::SchemaSwitcher)
        .to receive(:new)
        .with('foobar', ActiveRecord::Base.connection) { switcher }
      expect(switcher).to receive(:run) do |&block|
        expect(block).to be proc
      end

      subject.using('foobar', &proc)
    end
  end

  describe '.dump_schema' do
    it 'generates a dump of the schema' do
      dumper = double

      expect(MultitenancyTools::SchemaDumper)
        .to receive(:new)
        .with('foo', 'bar') { dumper }
      expect(dumper)
        .to receive(:dump_to).with('path/to/file.sql', mode: 'a')

      subject.dump_schema('foo', 'bar', 'path/to/file.sql', mode: 'a')
    end
  end

  describe '.dump_table' do
    it 'generates a dump of the table' do
      dumper = double

      expect(MultitenancyTools::TableDumper)
        .to receive(:new)
        .with('foo', 'bar', 'baz') { dumper }
      expect(dumper)
        .to receive(:dump_to).with('path/to/file.sql', mode: 'a')

      subject.dump_table('foo', 'bar', 'baz', 'path/to/file.sql', mode: 'a')
    end
  end
end
