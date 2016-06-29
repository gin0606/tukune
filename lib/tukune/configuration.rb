require_relative 'configuration/default'
require_relative 'configuration/travis_ci'
require_relative 'configuration/circle_ci'

module Tukune
  def self.configuration
    case
    when ENV["TRAVIS"]
      @configuration ||= Configuration::TravisCI.new
    when ENV["CIRCLECI"]
      @configuration ||= Configuration::CircleCI.new
    else
      @configuration ||= Configuration::Default.new
    end
  end
end
