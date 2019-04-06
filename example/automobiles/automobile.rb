class Automobile
  extend Industrialist::Manufacturable

  def info
    puts self.class.name
  end
end
