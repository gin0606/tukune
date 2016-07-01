require 'octokit'
require 'mem'

class Github
  include Mem

  def initialize(repo, current_branch = 'master')
    @repo = repo
    @current_branch = current_branch
  end

  def branch(name)
    client.create_ref(@repo, "heads/#{name}", current_branch[:object][:sha])
  end

  def checkout(branch)
    @current_branch = branch
  end

  def add(path)
    added_files << path
  end

  def commit(message)
    commit = client.commit(@repo, current_branch[:object][:sha])
    current_tree = client.tree(@repo, commit[:commit][:tree][:sha], recursive: true)
    tree = client.create_tree(@repo, changed_blobs, base_tree: current_tree[:sha])
    new_commit = client.create_commit(@repo, message, tree[:sha], current_branch[:object][:sha])
    client.update_branch(@repo, @current_branch, new_commit[:sha])

    added_files.clear

    new_commit
  end

  def pull_request(base, title, body)
    return
    client.create_pull_request(
      @repo,
      base,
      @current_branch,
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

  def current_branch
    @current_branches ||= {}
    return @current_branches[@current_branch] if @current_branches[@current_branch]
    @current_branches[@current_branch] = client.ref(@repo, "heads/#{@current_branch}")
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
end
