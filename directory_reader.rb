class DirectoryReader
  def initialize(path)
    path = "#{path}/**/*"
    @directory = Dir[path]
  end

  def all_file_paths
    @directory.select do |path|
      File.file? path
    end
  end

  def todo_file_paths
    all_file_paths.select do |file|
      data_as_string = File.read(file)
      data_as_string.upcase.include? "TODO"
    end
  end
end

new_directory = DirectoryReader.new('test_dir')
puts new_directory.todo_file_paths