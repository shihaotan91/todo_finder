require './file_analyzer'
require "byebug"

class DirectoryReader
  attr_reader :directory

  def initialize(dir)
    path = "./#{dir}/**/*"
    @directory = Dir[path]
  end

  def todo_file_paths
    file_paths.select do |file|
      analyzer = FileAnalyzer.new(file)
      analyzer.todo_present?
    end
  end

  def file_paths
    @directory.select do |path|
      File.file? path
    end
  end
end

directory_reader = DirectoryReader.new('test_dir')
puts directory_reader.todo_file_paths
