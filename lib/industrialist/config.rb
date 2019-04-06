module Industrialist
  class Config
    class << self
      attr_writer :require_method

      def manufacturable_paths
        @manufacturable_paths ||= []
      end

      def load_manufacturables
        manufacturable_paths.each { |path| Dir["#{path}/**/*.rb"].each { |file| Kernel.public_send(require_method, file) } }
      end

      private

      def require_method
        @require_method || :require
      end
    end
  end

  def self.config
    yield(Config)

    Config.load_manufacturables
  end
end
