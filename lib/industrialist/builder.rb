require 'industrialist/registrar'

module Industrialist
  class Builder
    def self.build(type, key, *args)
      klass = Registrar.value_for(type, key)
      Object.const_get(klass.name)&.new(*args) unless klass.nil?
    end
  end

  def self.build(*args)
    Builder.build(*args)
  end
end
