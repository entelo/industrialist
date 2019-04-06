require 'spec_helper'

RSpec.describe Industrialist::Factory do
  subject(:factory) { Class.new { extend Industrialist::Factory } }

  describe '#manufactures' do
    subject(:manufactures) { factory.manufactures(klass) }

    let(:klass) { String }
    let(:industrialized_string) { :string }

    before { manufactures }

    it 'sets a type on the factory' do
      expect(factory.instance_variable_get(:@type)).to eq(industrialized_string)
    end
  end

  describe '#build' do
    subject(:build) { factory.build(key, *args) }

    let(:klass) { String }
    let(:type) { :string }
    let(:key) { :key }
    let(:args) { [] }

    before do
      allow(Industrialist::Builder).to receive(:build).and_return(klass.new)
    end

    context 'when the type is nil' do
      it 'returns nil' do
        expect(build).to be_nil
      end
    end

    context 'when the type is NOT nil' do
      before do
        factory.manufactures(klass)
        build
      end

      it 'calls the builder to build the requested class' do
        expect(Industrialist::Builder).to have_received(:build).with(type, key, *args)
      end
    end
  end
end
