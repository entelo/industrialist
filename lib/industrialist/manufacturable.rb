require 'industrialist/factory'
require 'industrialist/warning_helper'

module Industrialist
  module Manufacturable
    extend WarningHelper

    ALREADY_INCLUDED_WARNING_MESSAGE = 'warning: a factory is already defined on this class hierarchy'.freeze

    def self.included(base)
      warning(ALREADY_INCLUDED_WARNING_MESSAGE) if base.class_variable_defined?(:@@factory)

      base.extend ClassMethods
      base.class_variable_set(:@@factory, Industrialist::Factory.new)
    end

    module ClassMethods
      def create_factory(identifier)
        Object.const_set(identifier, factory)
      end

      def corresponds_to(key)
        factory.register(key, self)
      end

      def factory
        class_variable_get(:@@factory)
      end
    end
  end
end
