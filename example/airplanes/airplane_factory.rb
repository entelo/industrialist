require_relative 'airplane'

class AirplaneFactory
  extend Industrialist::Factory

  manufactures Airplane
end
