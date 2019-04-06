module Industrialist
  class Type
    def self.industrialize(klass)
      str = klass.name
      str = separate_lowercase_or_number_from_uppercase_letters(str)
      str = separate_numbers_from_letters(str)
      str = separate_last_consecutive_uppercase_letter_when_followed_by_lowercase_letter(str)
      str.downcase.to_sym
    end

    def self.separate_lowercase_or_number_from_uppercase_letters(string)
      string.gsub(/[a-z0-9][A-Z]+/) { |s| "#{s[0]}_#{s[1..-1]}" }
    end

    def self.separate_numbers_from_letters(string)
      string.gsub(/[a-zA-Z][0-9]+/) { |s| "#{s[0]}_#{s[1..-1]}" }
    end

    def self.separate_last_consecutive_uppercase_letter_when_followed_by_lowercase_letter(string)
      string.gsub(/[A-Z][A-Z]+[a-z]/) { |s| "#{s[0..-3]}_#{s[-2..-1]}" }
    end
  end
end
