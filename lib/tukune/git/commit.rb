require 'octokit'
require 'mem'

module Tukune
  module Git
    class Commit
      include Mem

      def initialize(configuration)
        @repository_name = configuration.repository_name
        @current_branch = configuration.current_branch
        @feature_branch = configuration.feature_branch
      end

      def add(file_path)
        content = Base64.encode64(File.read(file_path))
        sha = client.create_blob(@repository_name, content, 'base64')
        blobs[file_path] = sha
      end

      def commit(message)
        changed_files = blobs.map { |path, _| path }
        changed_blobs = blobs.map do |file_path, sha|
          {
            path: file_path,
            mode: "100644",
            type: "blob",
            sha: sha
          }
        end
        current_blobs = current_tree[:tree].map { |e| e.to_h }

        trees = current_blobs.delete_if { |blob| changed_files.include?(blob[:path]) } + changed_blobs

        tree = client.create_tree(@repository_name, trees)
        commits << client.create_commit(@repository_name, message, tree[:sha], current_branch[:object][:sha])
      end

      private

      def current_tree
        commit = client.commit(@repository_name, current_branch[:object][:sha])
        client.tree(@repository_name, commit[:commit][:tree][:sha], recursive: true)
      end
      memoize :current_tree

      def current_branch
        client.ref(@repository_name, "heads/#{@current_branch}")
      end
      memoize :current_branch

      def create_feature_branch(name, sha)
        client.create_ref(@repository_name, "heads/#{name}", sha)
      end

      def commits
        []
      end
      memoize :commits

      def blobs
        {}
      end
      memoize :blobs

      def client
        ::Octokit::Client.new
      end
      memoize :client
    end
  end
end
