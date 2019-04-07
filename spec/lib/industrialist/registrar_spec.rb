require 'spec_helper'

RSpec.describe Industrialist::Registrar do
  let(:type) { :type }
  let(:key) { :key }
  let(:klass) { class_double('klass', name: 'Klass') }

  after { described_class.instance_variable_get(:@registry).clear }

  describe '.register' do
    subject(:register) { described_class.register(type, key, klass) }

    context 'when the key can be symbolized' do
      let(:key) { 'string_key' }
      let(:symbolized_key) { :string_key }

      before { register }

      it 'registers the class under the type and symbolized key' do
        expect(described_class.value_for(type, symbolized_key)).to be(klass)
      end

      it 'allows accessing the class under the type and  the original key' do
        expect(described_class.value_for(type, key)).to be(klass)
      end
    end

    context 'when the key cannot be symbolized' do
      let(:key) { { key: :value } }

      before { register }

      it 'registers the class under the type and key' do
        expect(described_class.value_for(type, key)).to be(klass)
      end
    end

    context 'when the key is already defined for a different class' do
      before do
        allow(Industrialist::WarningHelper).to receive(:warning)
        described_class.register(type, key, class_double('different_klass', name: 'Different'))

        register
      end

      it 'warns' do
        expect(Industrialist::WarningHelper).to have_received(:warning).with(described_class::REDEFINED_KEY_WARNING_MESSAGE)
      end
    end
  end

  describe '.register_default' do
    subject(:register_default) { described_class.register_default(type, klass) }

    let(:key) { described_class::DEFAULT_KEY }

    before { register_default }

    it 'registers the class under the type and default key' do
      expect(described_class.value_for(type, key)).to be(klass)
    end

    context 'when the default key is already defined for a different class' do
      before do
        allow(Industrialist::WarningHelper).to receive(:warning)

        described_class.register_default(type, class_double('different_klass', name: 'Different'))
      end

      it 'warns' do
        expect(Industrialist::WarningHelper).to have_received(:warning).with(described_class::REDEFINED_DEFAULT_WARNING_MESSAGE)
      end
    end
  end

  describe '.value_for' do
    context 'when the type is NOT registered' do
      let(:type) { :unregistered_type }

      it 'returns nil' do
        expect(described_class.value_for(type, key)).to be_nil
      end
    end

    context 'when the type is registered' do
      let(:type) { :registered_type }

      before { described_class.register(type, key, klass) }

      context 'and the key is NOT registered' do
        let(:accessed_key) { :unregistered_key }

        context 'and there is NOT a class under the default key' do
          it 'returns nil' do
            expect(described_class.value_for(type, accessed_key)).to be_nil
          end
        end

        context 'and there is a class under the default key' do
          before { described_class.register_default(type, klass) }

          it 'returns the class under the type and default key' do
            expect(described_class.value_for(type, accessed_key)).to be(klass)
          end
        end
      end

      context 'and the key is registered' do
        let(:accessed_key) { :registered_key }

        before { described_class.register(type, accessed_key, klass) }

        it 'returns the class under the type and key' do
          expect(described_class.value_for(type, accessed_key)).to be(klass)
        end
      end
    end
  end

  describe '.registered_types' do
    subject(:registered_types) { described_class.registered_types }

    let(:type1) { :type1 }
    let(:type2) { :type2 }

    before do
      described_class.register(type1, key, klass)
      described_class.register(type2, key, klass)
    end

    it 'returns the registered types' do
      expect(registered_types).to eq([type1, type2])
    end
  end

  describe '.registered_keys' do
    subject(:registered_keys) { described_class.registered_keys(type) }

    let(:key1) { :key1 }
    let(:key2) { :key2 }

    before do
      described_class.register(type, key1, klass)
      described_class.register(type, key2, klass)
    end

    it 'returns the registered types' do
      expect(registered_keys).to eq([key1, key2])
    end
  end
end
