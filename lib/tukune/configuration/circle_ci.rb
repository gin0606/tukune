require 'tukune/configuration'

module Tukune
  class Configuration
    class CircleCI < Default
      def repository_name
        "#{ENV['CIRCLE_PROJECT_USERNAME']}/#{ENV['CIRCLE_PROJECT_REPONAME']}"
      end

      def current_branch
        ENV['CIRCLE_BRANCH']
      end
    end
  end
end
