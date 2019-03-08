require 'spec_helper'

RSpec.describe Industrialist::Factory do
  subject(:factory) { described_class.new }

  let(:key) { :key }
  let(:klass) do
    class TestDummy
      def initialize(_args); end
    end

    TestDummy
  end

  before { factory.register(key, klass) }

  describe '#register' do
    it 'stores the provided class under the provided key' do
      expect(factory.registry[key]).to eq(klass)
    end
  end

  describe '#build' do
    subject(:build) { factory.build(key, params) }

    let(:params) { 'params' }

    before do
      allow(klass).to receive(:new).and_call_original
    end

    it 'builds an instance of the requested class' do
      build

      expect(klass).to have_received(:new).with(params)
    end

    it 'returns an instance of the right class' do
      expect(build).to be_a(klass)
    end
  end
end
