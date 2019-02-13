require 'spec_helper'

describe MultitenancyTools::Dump do
  describe '.call' do
    it 'calls pg_dump' do
      allow(Open3).to receive(:capture3)

      described_class.call(schema: 'shima',
                           database: 'db',
                           host: 'db.com',
                           username: 'kleber')

      expect(Open3)
        .to have_received(:capture3)
        .with(%q{pg_dump --schema shima --schema-only --no-privileges
                         --no-tablespaces --no-owner --dbname db
                         --host db.com --username kleber}.split.join(' '))
    end

    context 'when host is not provided' do
      it 'does not pass host as option' do
        allow(Open3).to receive(:capture3)

        described_class.call(schema: 'shima',
                             database: 'db',
                             username: 'kleber')

        expect(Open3)
          .to have_received(:capture3)
          .with(%q{pg_dump --schema shima --schema-only --no-privileges
                         --no-tablespaces --no-owner --dbname db
                         --username kleber}.split.join(' '))
      end

      it 'does not pass host as option when its value is nil' do
        allow(Open3).to receive(:capture3)

        described_class.call(schema: 'shima',
                             database: 'db',
                             host: nil,
                             username: 'kleber')

        expect(Open3)
          .to have_received(:capture3)
          .with(%q{pg_dump --schema shima --schema-only --no-privileges
                         --no-tablespaces --no-owner --dbname db
                         --username kleber}.split.join(' '))
      end
    end

    context 'when username is not provided' do
      it 'does not pass username as option' do
        allow(Open3).to receive(:capture3)

        described_class.call(schema: 'shima',
                             database: 'db',
                             host: 'db.com')

        expect(Open3)
          .to have_received(:capture3)
          .with(%q{pg_dump --schema shima --schema-only --no-privileges
                         --no-tablespaces --no-owner --dbname db
                         --host db.com}.split.join(' '))
      end

      it 'does not pass username as option when its value is nil' do
        allow(Open3).to receive(:capture3)

        described_class.call(schema: 'shima',
                             database: 'db',
                             host: 'db.com',
                             username: nil)

        expect(Open3)
          .to have_received(:capture3)
          .with(%q{pg_dump --schema shima --schema-only --no-privileges
                         --no-tablespaces --no-owner --dbname db
                         --host db.com}.split.join(' '))
      end
    end

    context 'when schema is not provided' do
      it 'raises an error' do
        expect do
          described_class.call(database: 'db')
        end.to raise_error KeyError, 'key not found: :schema'
      end
    end

    context 'when database is not provided' do
      it 'raises an error' do
        expect do
          described_class.call(schema: 'shima')
        end.to raise_error KeyError, 'key not found: :database'
      end
    end
  end
end
