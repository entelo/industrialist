require 'spec_helper'

RSpec.describe Industrialist::Builder do
  describe '.build' do
    subject(:build) { described_class.build(type, key, arg1, arg2) }

    let(:type) { :type }
    let(:key) { :key }
    let(:arg1) { 'arg1' }
    let(:arg2) { 'arg2' }
    let(:klass) { nil }

    before { allow(Industrialist::Registrar).to receive(:value_for).and_return(klass) }

    it 'retrieves the class registered under the type and key' do
      build
      expect(Industrialist::Registrar).to have_received(:value_for).with(type, key)
    end

    context 'when the registrar returns nil' do
      let(:klass) { nil }

      it 'returns nil' do
        expect(build).to be_nil
      end
    end

    context 'when the registrar returns a class' do
      let(:klass) { class Klass; end; Klass }
      let(:instance) { instance_double(klass) }

      before { allow(klass).to receive(:new).and_return(instance) }

      it 'builds an instance of the class with the provided arguments' do
        build
        expect(klass).to have_received(:new).with(arg1, arg2)
      end

      it 'returns the instance' do
        expect(build).to eq(instance)
      end
    end
  end
end
