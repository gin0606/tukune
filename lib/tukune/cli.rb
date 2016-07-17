module Tukune
  class CLI
    class << self
      def start(options)
        config = Tukune.configuration
        diff = Tukune::Git::Diff.name_status(options[:target_paths])
        if config.tukune_branch?
          puts 'this branch is tukune'
          return
        end
        if diff.nothing_to_commit?
          puts 'nothing to commit, working directory clean'
          return
        end

        github = Github.new(config.repository_name, config.current_branch)
        github.branch(config.feature_branch)
        github.checkout(config.feature_branch)

        diff.modified_files.each do |f|
          github.add(f)
          puts "Create #{f}."
        end
        diff.added_files.each do |f|
          github.add(f)
          puts "Create #{f}."
        end
        p github.commit("#{options[:title]}\n\n#{options[:body]}")
        puts 'Create commit'
        github.pull_request(config.current_branch, options[:title], options[:body])
        puts 'Create pull request'
      end
    end
  end
end
