require 'spec_helper'

RSpec.describe Industrialist::Manufacturable do
  before(:all) do
    class Automobile
      extend Industrialist::Manufacturable
    end
    class Book
      extend Industrialist::Manufacturable
    end
  end

  before do
    allow(Industrialist::WarningHelper).to receive(:warning).and_call_original
  end

  describe '.extended' do
    let(:industrialized_string) { :automobile }

    it 'sets a type on the factory' do
      expect(Automobile.class_variable_get(:@@type)).to eq(industrialized_string)
    end
  end

  describe '.corresponds_to' do
    before(:all) do
      class Sedan < Automobile
        corresponds_to :sedan
      end
      class Paperback < Book
        corresponds_to :paperback
      end
      class Coupe < Automobile
        corresponds_to :coupe
      end
    end

    it 'registers the class under the provided key' do
      expect(Industrialist.build(:automobile, :sedan)).to be_a(Sedan)
      expect(Industrialist.build(:automobile, :coupe)).to be_a(Coupe)
      expect(Industrialist.build(:book, :paperback)).to be_a(Paperback)
    end

    it 'does NOT register the class in other factories' do
      expect(Industrialist.build(:book, :sedan)).to be_nil
      expect(Industrialist.build(:book, :coupe)).to be_nil
      expect(Industrialist.build(:automobile, :paperback)).to be_nil
    end
  end

  describe '.manufacturable_default' do
    before(:all) do
      class Sedan < Automobile
        manufacturable_default
      end
    end

    it 'registers the class under the default key' do
      expect(Industrialist.build(:automobile, :clown_car)).to be_a(Sedan)
    end
  end
end
