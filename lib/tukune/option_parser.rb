module Tukune
  class OptionParser
    def initialize
      @opt_parser = ::OptionParser.new do |opt|
        opt.banner = 'Usage: tukune [OPTIONS]'
        opt.separator  ''
        opt.separator  'Options'

        opt.on('-t', '--title TITLE', 'Pull request title') do |title|
          @title = title
        end

        opt.on('-b', '--body BODY', 'Pull request body') do |body|
          @body = body
        end

        opt.on('--target-path V,V...', Array) do |path|
          @target_paths = path
        end

        opt.on('--enable-all') do |enable_all|
          @enable_all = enable_all
        end

        opt.on('-h', '--help', 'help') do
          puts @opt_parser
        end
      end
    end

    def parse!(argv = @opt_parser.default_argv)
      @opt_parser.parse!(argv)
    end

    def options
      {
        title: @title,
        body: @body,
        enable_all: @enable_all,
        target_paths: @target_paths || []
      }
    end
  end
end
