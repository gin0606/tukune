require 'mem'

class Github
  include Mem

  def initialize(repo, current_branch='master')
    @repo = repo
    @current_branch = current_branch
  end

  def branch(name)
    client.create_ref(@repository_name, "heads/#{name}", current_branch[:object][:sha])
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
    if deleted_files.empty?
      # current_branchのtree取得する
      # added_filesのblob作る
      # client.create_tree(@repository_name, changed_blobs, base_tree: current_tree[:sha])
      # client.create_commit(@repository_name, message, tree[:sha], current_branch[:object][:sha])

    else
    end

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
