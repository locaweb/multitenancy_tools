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

    context 'chained calls with the same schema name' do
      it 'sets the search path to its previous value only in the last call' do
        expect(Db.connection)
          .to receive(:schema_search_path=).ordered.once.with("'foobar'").and_call_original
        expect(Db.connection)
          .to receive(:schema_search_path=).ordered.once.with('something').and_call_original

        subject.run { subject.run {} }
      end
    end

    context 'chain with different shard names' do
      it 'returns connections back to the pool' do
        expect(Db.connection)
          .to receive(:schema_search_path=).ordered.once.with("'foo'").and_call_original
        expect(Db.connection)
          .to receive(:schema_search_path=).ordered.once.with("'bar'").and_call_original
        expect(Db.connection)
          .to receive(:schema_search_path=).ordered.once.with("'foo'").and_call_original
        expect(Db.connection)
          .to receive(:schema_search_path=).ordered.once.with('something').and_call_original

        described_class.new('foo', Db.connection).run do
          described_class.new('bar', Db.connection).run do
          end
        end
      end
    end
  end
end
