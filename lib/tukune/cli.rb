module Tukune
  class CLI
    class << self
      def start(options)
        p options
        p Git.new.modified_files
      end
    end
  end
end
