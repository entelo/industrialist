require 'industrialist/factory'

module Industrialist
  module Manufacturable
    def self.included(base)
      base.extend ClassMethods
      base.instance_variable_set(:@factory, Industrialist::Factory.new)
    end

    module ClassMethods
      def inherited(base)
        base.instance_variable_set(:@factory, @factory)
      end

      def create_factory(identifier)
        Object.const_set(identifier, @factory)
      end

      def corresponds_to(key)
        @factory.register(key, self)
      end
    end
  end
end
