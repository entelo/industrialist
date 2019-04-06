require_relative 'automobile'

class AutomobileFactory
  extend Industrialist::Factory

  manufactures Automobile
end
