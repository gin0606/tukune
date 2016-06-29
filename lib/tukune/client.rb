require 'octokit'
require 'mem'

module Tukune
  class Client
    include Mem

    attr_reader :repository_name, :base_branch, :feature_branch_name

    def initialize(configuration)
      @repository_name = configuration.repository_name
      @base_branch = configuration.current_branch
      @feature_branch_name = configuration.feature_branch
    end

    def add_file(path, message=nil)
      client.create_contents(
        repository_name,
        path,
        message || "Add #{path}",
        branch: feature_branch,
        file: path
      )
    end

    def update_file(path, message=nil)
      content = client.contents(repository_name, path: path, ref: feature_branch)
      client.update_contents(
        repository_name,
        path,
        message || "Update #{path}",
        content[:sha],
        branch: feature_branch,
        file: path
      )
    end

    def delete_file(path, message=nil)
      content = client.contents(repository_name, path: path, ref: feature_branch)
      client.delete_contents(
        repository_name,
        path,
        message || "Delete #{path}",
        content[:sha],
        branch: feature_branch,
      )
    end

    def create_pull_request(title, body)
      client.create_pull_request(
        repository_name,
        base_branch,
        feature_branch,
        "Pull Request Title",
        "Pull Request Body"
      )
    end

    private

    def client
      ::Octokit::Client.new
    end
    memoize :client

    def feature_branch
      create_feature_branch
      feature_branch_name
    end

    def create_feature_branch
      return if client.refs(repository_name).any? {|ref| ref[:ref] == "refs/heads/#{feature_branch_name}" }
      sha = client.ref(repository_name, "heads/#{base_branch}")[:object][:sha]
      client.create_ref(repository_name, "heads/#{feature_branch_name}", sha)
    end
    memoize :create_feature_branch
  end
end
