module Tukune
  class CLI
    class << self
      def start(options)
        if tukune?
          puts "this branch is tukune"
          return
        end
        unless Tukune.configuration.pull_request?
          puts "This build is not part of pull request."
          puts "If you want to exec tukune, try to use `--enable-all` option."
          return
        end
        diff = Tukune::Git::Diff.name_status
        if diff.nothing_to_commit?
          puts "nothing to commit, working directory clean"
          return
        end
        c = Tukune::Git::Commit.new(Tukune.configuration)
        diff.modified_files.each do |f|
          c.add(f)
          puts "Create #{f} blob."
        end
        diff.added_files.each do |f|
          c.add(f)
          puts "Create #{f} blob."
        end
        # diff.deleted_files.each {|f| c.delete(f) }
        c.commit("#{options[:title]}\n\n#{options[:body]}")
        puts "Create commit"
        c.pull_request(options[:title], options[:body])
        puts "Create pull request"
      end

      def tukune?
        Tukune.configuration.current_branch.start_with?("tukune_")
      end
    end
  end
end
