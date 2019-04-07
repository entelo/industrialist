require 'industrialist/type'
require 'industrialist/warning_helper'

module Industrialist
  class Registrar
    DEFAULT_KEY = :__manufacturable_default__
    REDEFINED_KEY_WARNING_MESSAGE = 'warning: overriding a previously registered class'.freeze
    REDEFINED_DEFAULT_WARNING_MESSAGE = 'warning: overriding a previously registered default class'.freeze

    class << self
      def register(type, key, klass)
        WarningHelper.warning(REDEFINED_KEY_WARNING_MESSAGE) if overriding?(type, key, klass)

        registry[type][registry_key(key)] = klass
      end

      def register_default(type, klass)
        WarningHelper.warning(REDEFINED_DEFAULT_WARNING_MESSAGE) if overriding?(type, DEFAULT_KEY, klass)

        registry[type][DEFAULT_KEY] = klass
      end

      def value_for(type, key)
        return unless registry.key?(type)

        registry[type][registry_key(key)] || registry[type][DEFAULT_KEY]
      end

      def registered_types
        registry.keys
      end

      def registered_keys(type)
        registry[type].keys
      end

      private

      def registry_key(key)
        (key.respond_to?(:to_sym) && key.to_sym) || key
      end

      def overriding?(type, key, klass)
        !registry[type][key].nil? && registry[type][key].name != klass.name
      end

      def registry
        @registry ||= Hash.new { |hash, key| hash[key] = {} }
      end
    end
  end

  def self.registered_types
    Registrar.registered_types
  end

  def self.registered_keys(type)
    Registrar.registered_keys(type)
  end
end
