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

      def pull_request?
        ENV["TRAVIS_PULL_REQUEST"] != "false"
      end
    end
  end
end
