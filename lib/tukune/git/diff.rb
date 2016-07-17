require 'mem'

module Tukune
  module Git
    class Diff
      include Mem

      attr_reader :changed_files

      def initialize(target_paths)
        @target_paths = target_paths.join(' ')
      end

      def nothing_to_commit?
        changed_files.empty?
      end

      def added_files
        `git ls-files --others --exclude-standard #{@target_paths}`.strip.split("\n")
      end
      memoize :added_files

      def modified_files
        changed_files.select { |type, _| type == 'M' }.map { |_, name| name }
      end
      memoize :modified_files

      def deleted_files
        changed_files.select { |type, _| type == 'D' }.map { |_, name| name }
      end
      memoize :deleted_files

      def changed_files
        @changed_files ||= `git diff --name-status #{@target_paths}`.strip.split("\n").map { |e| e.split("\t") }
      end
      memoize :changed_files

      class << self
        def name_status(target_paths = [])
          Diff.new(target_paths)
        end
      end
    end
  end
end
