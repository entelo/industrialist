require 'spec_helper'

RSpec.describe Industrialist do
  describe '.config' do
    before { allow(Industrialist::Config).to receive(:load_manufacturables) }

    it 'yields Config the the provided block' do
      expect { |b| described_class.config(&b) }.to yield_with_args(Industrialist::Config)
    end

    it 'delegates loading manufacturables to Config' do
      described_class.config {}

      expect(Industrialist::Config).to have_received(:load_manufacturables)
    end
  end

  describe '.build' do
    subject(:build) { described_class.build(arg1, arg2) }

    let(:arg1) { :arg1 }
    let(:arg2) { :arg2 }

    before do
      allow(Industrialist::Builder).to receive(:build)

      build
    end

    it 'delegates build to Builder' do
      expect(Industrialist::Builder).to have_received(:build).with(arg1, arg2)
    end
  end

  describe '.registered_types' do
    subject(:registered_types) { described_class.registered_types }

    before do
      allow(Industrialist::Registrar).to receive(:registered_types)

      registered_types
    end

    it 'delegates registered_types to Registrar' do
      expect(Industrialist::Registrar).to have_received(:registered_types)
    end
  end

  describe '.registered_keys' do
    subject(:registered_keys) { described_class.registered_keys(type) }

    let(:type) { :type }

    before do
      allow(Industrialist::Registrar).to receive(:registered_keys)

      registered_keys
    end

    it 'delegates registered_keys to Registrar' do
      expect(Industrialist::Registrar).to have_received(:registered_keys).with(type)
    end
  end
end