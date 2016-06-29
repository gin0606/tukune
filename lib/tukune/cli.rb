module Tukune
  class CLI
    class << self
      def start(options)
        diff = Tukune::Git::Diff.name_status
        if diff.nothing_to_commit?
          puts "nothing to commit, working directory clean"
          return
        end
        client = Tukune::Client.new(repository_name, current_branch)
        diff.added_files.each {|file| client.add_file(file) }
        diff.modified_files.each {|file| client.update_file(file) }
        diff.deleted_files.each {|file| client.delete_file(file) }
        client.create_pull_request(options[:title], options[:body])
      end

      def repository_name
        ENV["TRAVIS_REPO_SLUG"] || "#{ENV["CIRCLE_PROJECT_USERNAME"]}/#{ENV["CIRCLE_PROJECT_REPONAME"]}"
      end

      def current_branch
        ENV["TRAVIS_BRANCH"] || ENV['CIRCLE_BRANCH'] || `git symbolic-ref --short HEAD`.strip
      end
    end
  end
end
