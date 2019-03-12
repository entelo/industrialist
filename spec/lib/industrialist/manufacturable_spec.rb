require 'spec_helper'

RSpec.describe Industrialist::Manufacturable do
  before do
    class Automobile
      include Industrialist::Manufacturable
      create_factory :AutomobileFactory
    end
  end

  describe '.factory_name' do
    it 'assigns the provided name to the factory instance' do
      expect(AutomobileFactory).to be_an(Industrialist::Factory)
    end
  end

  describe '.corresponds_to' do
    before do
      class Sedan < Automobile
        corresponds_to :sedan
      end
    end

    it 'registers the class under the provided key' do
      expect(AutomobileFactory.registry[:sedan]).to equal(Sedan)
    end
  end
end
