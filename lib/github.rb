require 'mem'

class Github
  include Mem

  def initialize(repo, current_branch='master')
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
    deleted_files.delete(path)
    added_files << path
  end

  def delete(path)
    added_files.delete(path)
    deleted_files << path
  end

  def commit(message)
    changed_blobs = added_files.map do |path|
      content = Base64.encode64(File.read(path))
      sha = client.create_blob(@repo, content, 'base64')
      { path: path, mode: '100644', type: 'blob', sha: sha }
    end
    commit = client.commit(@repo, current_branch[:object][:sha])

    current_tree = client.tree(@repo, commit[:commit][:tree][:sha], recursive: true)
    unless deleted_files.empty?
      changed_blobs = current_tree
      changed_blobs.delete_if {|tree| added_files.include?(tree[:path]) }
      changed_blobs.delete_if {|tree| deleted_files.include?(tree[:path]) }
      changed_blobs.concat(current_tree)
    end

    tree = client.create_tree(@repo, changed_blobs, base_tree: current_tree[:sha])
    client.create_commit(@repo, message, tree[:sha], current_branch[:object][:sha])

    added_files.clear
    deleted_files.clear
  end

  private

  def current_branch
    client.ref(@repo, "heads/#{@current_branch}")
  end

  def create_blob(path)
    content = Base64.encode64(File.read(path))
    client.create_blob(@repo, content, 'base64')
  end

  def added_files
    []
  end
  memoize :added_files

  def deleted_files
    []
  end
  memoize :deleted_files

end
