require "tukune/configuration"

module Tukune
  class Configuration
    class TravisCI < Default
      def repository_name
        ENV["TRAVIS_REPO_SLUG"]
      end

      def current_branch
        ENV["TRAVIS_BRANCH"]
      end
    end
  end
end
