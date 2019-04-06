require 'industrialist/config'

module Industrialist
  class Railtie < Rails::Railtie
    initializer "industrialist.configure_rails_initialization" do |app|
      Industrialist::Config.require_method = app.config.eager_load ? :require : :require_dependency
    end
  end
end
