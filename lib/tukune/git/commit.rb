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
        p current_tree
        trees = blobs.map { |file_path, sha|
          {
            path: file_path,
            mode: "100644",
            type: "blob",
            sha: sha
          }
        }
        tree = client.create_tree(@repository_name, trees)
        commit = client.create_commit(@repository_name, message, tree[:sha], current_branch[:object][:sha])
        feature_branch = create_feature_branch(@feature_branch, commit[:sha])
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
