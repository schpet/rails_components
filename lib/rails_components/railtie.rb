require 'rails_components/view_helpers'
module RailsComponents
  class Railtie < Rails::Railtie
    initializer "my_gem.component_helper" do
      ActionView::Base.send :include, ComponentHelper
    end
  end
end
