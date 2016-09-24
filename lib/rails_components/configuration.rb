# https://robots.thoughtbot.com/mygem-configure-block
module RailsComponents
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :template_directory

    def initialize
      @template_directory = 'components'
    end
  end
end
