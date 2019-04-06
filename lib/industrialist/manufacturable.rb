require 'industrialist/registrar'
require 'industrialist/type'

module Industrialist
  module Manufacturable
    def self.extended(base)
      base.class_variable_set(:@@type, Type.industrialize(base))
    end

    def corresponds_to(key)
      Registrar.register(self.class_variable_get(:@@type), key, self)
    end

    def manufacturable_default
      Registrar.register_default(self.class_variable_get(:@@type), self)
    end
  end
end
