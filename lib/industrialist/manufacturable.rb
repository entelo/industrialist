require 'industrialist/factory'
require 'industrialist/warning_helper'

module Industrialist
  module Manufacturable
    ALREADY_INCLUDED_WARNING_MESSAGE = 'warning: overriding previously defined factory on this class hierarchy'.freeze
    MULTIPLE_DEFAULT_WARNING_MESSAGE = 'warning: overriding a previously registered default class'.freeze

    def self.included(base)
      WarningHelper.warning(ALREADY_INCLUDED_WARNING_MESSAGE) if base.class_variable_defined?(:@@factory)

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

      def manufacturable_default
        WarningHelper.warning(MULTIPLE_DEFAULT_WARNING_MESSAGE) if factory.registry[Industrialist::Factory::DEFAULT_KEY]

        factory.register(Industrialist::Factory::DEFAULT_KEY, self)
      end

      def factory
        class_variable_get(:@@factory)
      end
    end
  end
end
