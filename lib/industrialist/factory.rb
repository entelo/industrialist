require 'industrialist/builder'

module Industrialist
  module Factory
    def manufactures(klass)
      @type = Type.industrialize(klass)
    end

    def build(key, *args)
      return if @type.nil?

      Builder.build(@type, key, *args)
    end
  end
end
