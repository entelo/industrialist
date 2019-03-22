module Industrialist
  module WarningHelper
    def warning(message)
      most_recent_caller = caller(2..2).first.split(':')
      file_name = most_recent_caller[0]
      line_number = most_recent_caller[1]
      warn("#{file_name}:#{line_number}: #{message}")
    end
  end
end
