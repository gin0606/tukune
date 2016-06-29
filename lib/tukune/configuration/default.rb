module Tukune
  class Configuration
    class Default
      include Mem

      def repository_name
        raise "You need to set TUKUNE_REPONAME in environment variables" unless ENV["TUKUNE_REPONAME"]
        ENV["TUKUNE_REPONAME"]
      end

      def current_branch
        `git symbolic-ref --short HEAD`.strip
      end

      def feature_branch_prefix
        "tukune_"
      end

      def feature_branch
        feature_branch_prefix + current_branch
      end
      memoize :feature_branch
    end
  end
end
