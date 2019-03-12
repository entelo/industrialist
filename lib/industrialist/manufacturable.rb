require 'industrialist/factory'

module Industrialist
  module Manufacturable
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      @@factory = Industrialist::Factory.new

      def create_factory(identifier)
        Object.const_set(identifier, @@factory)
      end

      def corresponds_to(key)
        @@factory.register(key, self)
      end
    end
  end
end
