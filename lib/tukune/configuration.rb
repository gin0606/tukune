require_relative 'configuration/default'
require_relative 'configuration/travis_ci'
require_relative 'configuration/circle_ci'

module Tukune
  def self.configuration
    @configuration ||= if ENV['TRAVIS']
                         Configuration::TravisCI.new
                       elsif ENV['CIRCLECI']
                         Configuration::CircleCI.new
                       else
                         Configuration::Default.new
                       end
  end
end
