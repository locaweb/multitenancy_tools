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
end
