require 'spec_helper'

RSpec.describe MultitenancyTools::SchemaSwitcher do
  subject { described_class.new('foobar', Db.connection) }

  describe '#execute' do
    before do
      Db.connection.schema_search_path = 'something'
    end

    it 'receives and executes a block' do
      expect do |b|
        subject.run(&b)
      end.to yield_control
    end

    it 'sets the correct search path when executing the block' do
      subject.run do
        expect(Db.connection.schema_search_path).to eql("'foobar'")
      end
    end

    it 'sets the search path back to its previous value' do
      subject.run {}
      expect(Db.connection.schema_search_path).to eql("something")
    end

    it 'sets the search path back to its previous value when an error occurs' do
      expect do
        subject.run { fail 'OMG' }
      end.to raise_error(/OMG/)
      expect(Db.connection.schema_search_path).to eql('something')
    end
  end
end
