require 'spec_helper'

RSpec.describe MultitenancyTools do
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
