require 'industrialist'

Industrialist.config do |config|
  config.manufacturable_paths << "#{File.dirname(__FILE__)}/automobiles"
  config.manufacturable_paths << "#{File.dirname(__FILE__)}/airplanes"
end

AutomobileFactory.build(:sedan).info
AutomobileFactory.build(:convertible).info
AutomobileFactory.build(:cabriolet).info

AirplaneFactory.build(:f16).info
AirplaneFactory.build(:tomcat).info
AirplaneFactory.build(:p51).info
AirplaneFactory.build(:mustang).info
