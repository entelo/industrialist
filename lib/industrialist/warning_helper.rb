module Industrialist
  class WarningHelper
    def self.warning(message)
      warn("#{caller(3..3).first}: #{message}")
    end
  end
end
