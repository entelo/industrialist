require 'spec_helper'

RSpec.describe Industrialist::Manufacturable do
  def undefine_constants(*consts)
    consts.each { |const| Object.send(:remove_const, const) }
  end

  around do |example|
    class Automobile
      include Industrialist::Manufacturable
      create_factory :AutomobileFactory
    end
    class Book
      include Industrialist::Manufacturable
      create_factory :BookFactory
    end
    example.run
    undefine_constants(:Automobile, :Book, :AutomobileFactory, :BookFactory)
  end


  describe '.factory_name' do
    it 'assigns the provided name to the factory instance' do
      expect(AutomobileFactory).to be_an(Industrialist::Factory)
    end
  end

  describe '.corresponds_to' do
    around do |example|
      class Sedan     < Automobile; corresponds_to :sedan    ; end
      class Paperback < Book      ; corresponds_to :paperback; end
      example.run
      undefine_constants(:Sedan, :Paperback)
    end

    it 'registers the class under the provided key' do
      expect(AutomobileFactory.registry[:sedan]).to equal(Sedan)
      expect(BookFactory.registry[:paperback]).to equal(Paperback)
    end

    it 'registers the class only under the provided key' do
      expect(AutomobileFactory.registry[:paperback]).to be_nil
      expect(BookFactory.registry[:sedan]).to be_nil
    end
  end
end
