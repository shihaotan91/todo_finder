require "byebug"

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
      data_in_lines = File.readlines(file)
      valid_lines = data_in_lines.select do |line|
        line.start_with?('//') && line.include?('TODO:')
      end
      valid_lines.length.positive?
    end
  end
end

new_directory = DirectoryReader.new('test_dir')
puts new_directory.todo_file_paths