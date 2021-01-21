module FileHelpers
  def temp_dir
    directory = File.expand_path('../tmp', __dir__)
    FileUtils.mkdir(directory) unless Dir.exist?(directory)
    directory
  end

  def remove_temp_dir
    FileUtils.remove_dir(temp_dir, true)
  end

  def temp_file(filename)
    File.join(temp_dir, filename)
  end

  def resources_file(filename)
    path = File.expand_path('resources', __dir__)
    File.join(path, filename)
  end
end
