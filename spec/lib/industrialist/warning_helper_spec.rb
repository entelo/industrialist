require 'spec_helper'

RSpec.describe Industrialist::WarningHelper do
  describe '.warning' do
    subject(:warning) { described_class.warning(message) }

    let(:message) { 'Warning!' }
    let(:call_stack) { ["file_name:line_number", "ignored", "ignored"] }

    before do
      allow(described_class).to receive(:caller).and_return(call_stack)
      allow(described_class).to receive(:warn)

      warning
    end

    it 'grabs the fourth item from the callstack' do
      expect(described_class).to have_received(:caller).with(3..3)
    end

    it 'warns with the caller location inclding the line number' do
      expect(described_class).to have_received(:warn).with(a_string_including("file_name:line_number"))
    end

    it 'warns with the supplied message' do
      expect(described_class).to have_received(:warn).with(a_string_including(": #{message}"))
    end
  end
end