require_relative 'file_analyzer'

class DirectoryReader
  attr_accessor :directory

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

dir = ARGV[0]

unless File.directory?(dir)
  puts 'Invalid directory'
  return
end

directory_reader = DirectoryReader.new(dir)
puts directory_reader.todo_file_paths
