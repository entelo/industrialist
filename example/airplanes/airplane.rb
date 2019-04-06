class Airplane
  extend Industrialist::Manufacturable

  def info
    puts self.class.name
  end
end