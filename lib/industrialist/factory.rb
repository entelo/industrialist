module Industrialist
  class Factory
    attr_reader :registry

    def initialize
      @registry = {}
    end

    def register(key, klass)
      registry[key&.to_sym] = klass
    end

    def build(event_type, *args)
      klass = registry[event_type&.to_sym]
      klass&.new(*args)
    end
  end
end
