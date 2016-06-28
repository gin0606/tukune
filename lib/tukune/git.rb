module Tukune
  class Git
    def nothing_to_commit?
      changed_files.empty?
    end

    def added_files
      changed_files.select {|type, _| type == "A" }.map { |_, name| name }
    end

    def modified_files
      changed_files.select {|type, _| type == "M" }.map { |_, name| name }
    end

    def deleted_files
      changed_files.select {|type, _| type == "D" }.map { |_, name| name }
    end

    def changed_files
      @changed_files ||= `git diff --name-status`.strip.split("\n").map { |e| e.split("\t") }
    end
  end
end
