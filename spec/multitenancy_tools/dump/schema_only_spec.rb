require 'spec_helper'

describe MultitenancyTools::Dump::SchemaOnly do
  describe '#dump' do
    it 'calls pg_dump' do
      allow(Open3).to receive(:capture3)

      described_class.new(schema: 'shima',
                          database: 'db',
                          host: 'db.com',
                          username: 'kleber').dump

      expect(Open3)
        .to have_received(:capture3)
        .with(%q{pg_dump --schema shima --schema-only --no-privileges
                         --no-tablespaces --no-owner --dbname db --host db.com
                         --username kleber}.split.join(' '))
    end

    context 'when host is not provided' do
      it 'does not pass host as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            username: 'kleber').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--host/)
      end
    end

    context 'when host value is nil' do
      it 'does not pass host as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            host: nil,
                            username: 'kleber').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--host/)
      end
    end

    context 'when host value is an empty string' do
      it 'does not pass host as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            host: '',
                            username: 'kleber').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--host/)
      end
    end

    context 'when username is not provided' do
      it 'does not pass username as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            host: 'db.com').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--username/)
      end
    end

    context 'when username value is nil' do
      it 'does not pass username as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            username: nil,
                            host: 'db.com').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--username/)
      end
    end

    context 'when host value is an empty string' do
      it 'does not pass host as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            username: '',
                            host: 'db.com').dump


        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--username/)
      end
    end

    context 'when schema is not provided' do
      it 'raises an error' do
        expect do
          described_class.new(database: 'db').dump
        end.to raise_error KeyError, 'key not found: :schema'
      end
    end

    context 'when database is not provided' do
      it 'raises an error' do
        expect do
          described_class.new(schema: 'shima').dump
        end.to raise_error KeyError, 'key not found: :database'
      end
    end
  end
end
