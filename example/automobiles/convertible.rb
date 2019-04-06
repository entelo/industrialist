require_relative 'automobile'

class Convertible < Automobile
  corresponds_to :convertible
  corresponds_to :cabriolet
end
