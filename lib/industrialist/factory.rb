module Industrialist
  class Factory
    DEFAULT_KEY = :__manufacturable_default__

    attr_reader :registry

    def initialize
      @registry = {}
    end

    def register(key, klass)
      registry[factory_key(key)] = klass
    end

    def build(key, *args)
      klass = registry[factory_key(key)] || registry[DEFAULT_KEY]
      klass&.new(*args)
    end

    private

    def factory_key(key)
      (key.respond_to?(:to_sym) && key.to_sym) || key
    end
  end
end
