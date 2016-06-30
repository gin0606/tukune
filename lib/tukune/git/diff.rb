module Tukune
  module Git
    class Diff
      attr_reader :changed_files

      def initialize(changed_files)
        @changed_files = changed_files
      end

      def nothing_to_commit?
        changed_files.empty?
      end

      def added_files
        `git ls-files --others --exclude-standard`.strip.split("\n")
      end

      def modified_files
        changed_files.select { |type, _| type == 'M' }.map { |_, name| name }
      end

      def deleted_files
        changed_files.select { |type, _| type == 'D' }.map { |_, name| name }
      end

      class << self
        def name_status
          changed_files ||= `git diff --name-status`.strip.split("\n").map { |e| e.split("\t") }
          Diff.new(changed_files)
        end
      end
    end
  end
end
