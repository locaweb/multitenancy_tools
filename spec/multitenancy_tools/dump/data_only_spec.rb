require 'spec_helper'

describe MultitenancyTools::Dump::DataOnly do
  describe '#dump' do
    it 'calls pg_dump' do
      allow(Open3).to receive(:capture3)

      described_class.new(schema: 'shima',
                          database: 'db',
                          host: 'db.com',
                          username: 'kleber',
                          table: 'table').dump

      expect(Open3)
        .to have_received(:capture3)
        .with(%q{pg_dump --table shima.table --no-privileges
                         --no-tablespaces --no-owner --dbname db
                         --data-only --inserts --host db.com
                         --username kleber}.split.join(' '))
    end

    context 'when host is not provided' do
      it 'does not pass host as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            table: 'table',
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
                            table: 'table',
                            host: nil,
                            username: 'kleber').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--host/)
      end
    end

    context 'when host value is empty string' do
      it 'does not pass host as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            host: '',
                            table: 'table',
                            username: 'user').dump

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
                            table: 'table',
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
                            table: 'table',
                            host: 'db.com').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--username/)
      end
    end

    context 'when username value is empty string' do
      it 'does not pass username as option' do
        allow(Open3).to receive(:capture3)

        described_class.new(schema: 'shima',
                            database: 'db',
                            username: '',
                            table: 'table',
                            host: 'db.com').dump

        expect(Open3)
          .to_not have_received(:capture3)
          .with(/--username/)
      end
    end

    context 'when schema is not provided' do
      it 'raises an error' do
        expect do
          described_class.new(table: 'table', database: 'db').dump
        end.to raise_error KeyError, 'key not found: :schema'
      end
    end

    context 'when table is not provided' do
      it 'raises an error' do
        expect do
          described_class.new(schema: 'shima', database: 'db').dump
        end.to raise_error KeyError, 'key not found: :table'
      end
    end

    context 'when database is not provided' do
      it 'raises an error' do
        expect do
          described_class.new(schema: 'shima', database: 'db').dump
        end.to raise_error KeyError, 'key not found: :table'
      end
    end
  end
end
