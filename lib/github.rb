require 'octokit'
require 'mem'

class Github
  include Mem

  def initialize(repo, current_branch = 'master')
    @repo = repo
    @current_branch_name = current_branch
    @branch = BranchCache.new(repo)
  end

  def branch(name)
    current_branch = @branch.read(@current_branch_name)
    @branch.create(name, current_branch[:object][:sha])
  end

  def checkout(branch)
    @current_branch_name = branch
  end

  def add(path)
    added_files << path
  end

  class Tree
    include Mem

    def initialize(repo, branch_sha)
      @repo = repo
      @branch_sha = branch_sha
    end

    def add(path)
      content = Base64.encode64(File.read(path))
      sha = client.create_blob(@repo, content, 'base64')
      blobs << { path: path, mode: '100644', type: 'blob', sha: sha }
    end

    def create_tree
      client.create_tree(@repo, blobs, base_tree: current_tree[:sha])
    end

    def current_tree
      commit = client.commit(@repo, @branch_sha)
      client.tree(@repo, commit[:commit][:tree][:sha], recursive: true)
    end
    memoize :current_tree

    def blobs
      []
    end
    memoize :blobs

    def client
      ::Octokit::Client.new
    end
    memoize :client
  end

  def commit(message)
    current_branch = @branch.read(@current_branch_name)

    tree_helper = Tree.new(@repo, current_branch[:object][:sha])
    added_files.each { |path| tree_helper.add(path) }
    tree = tree_helper.create_tree

    new_commit = client.create_commit(@repo, message, tree[:sha], current_branch[:object][:sha])

    @branch.update(@current_branch_name, new_commit[:sha])

    added_files.clear

    new_commit
  end

  def pull_request(base, title, body)
    client.create_pull_request(
      @repo,
      base,
      @current_branch_name,
      title,
      body
    )
  end

  private

  def changed_blobs
    changed_blobs = added_files.map do |path|
      content = Base64.encode64(File.read(path))
      sha = client.create_blob(@repo, content, 'base64')
      { path: path, mode: '100644', type: 'blob', sha: sha }
    end
    changed_blobs
  end

  def create_blob(path)
    content = Base64.encode64(File.read(path))
    client.create_blob(@repo, content, 'base64')
  end

  def added_files
    []
  end
  memoize :added_files

  def client
    ::Octokit::Client.new
  end
  memoize :client

  class BranchCache
    include Mem

    def initialize(repo)
      @repo = repo
      @cache = {}
    end

    def create(name, sha)
      @cache[name] = client.create_ref(@repo, "heads/#{name}", sha)
    end

    def read(name)
      @cache[name] = client.ref(@repo, "heads/#{name}")
    end

    def update(name, sha)
      @cache[name] = client.update_branch(@repo, name, sha)
    end

    def delete(name)
      ref = client.delete_ref(@repo, "heads/#{name}")
      @cache.delete(name)
      ref
    end

    private

    def client
      ::Octokit::Client.new
    end
    memoize :client
  end
end
