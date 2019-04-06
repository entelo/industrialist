require 'spec_helper'

RSpec.describe Industrialist::Type do
  describe '.industrialize' do
    subject(:industrialize) { described_class.industrialize(klass) }

    let(:klass) { instance_double('klass', name: class_name) }

    context 'when the class name is a single word' do
      let(:class_name) { 'Word' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:word)
      end
    end

    context 'when the class name is a word with a number at the end' do
      let(:class_name) { 'Word1' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:word_1)
      end
    end

    context 'when the class name is two words' do
      let(:class_name) { 'TwoWords' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:two_words)
      end
    end

    context 'when the class name is two words with a number in the middle' do
      let(:class_name) { 'Two3Words' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:two_3_words)
      end
    end

    context 'when the class name contains consecutive capital letters' do
      let(:class_name) { 'LOUDWords' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:loud_words)
      end
    end

    context 'when the class name contains consecutive numbers' do
      let(:class_name) { 'Word123' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:word_123)
      end
    end

    context 'when the class name contains consecutive capital letters and consecutive numbers' do
      let(:class_name) { 'WORD123' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:word_123)
      end
    end

    context 'when the class name contains underscores' do
      let(:class_name) { 'Un_Der_Scöre' }

      it 'industrializes the class name' do
        expect(industrialize).to eq(:un_der_scöre)
      end
    end
  end
end
