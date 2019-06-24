require "byebug"

class DirectoryReader
  attr_reader :directory

  def initialize(dir)
    path = "#{dir}/**/*"
    @directory = Dir[path]
  end

  def file_paths
    @directory.select do |path|
      File.file? path
    end
  end

  def multi_line_comment?(line)
    line.start_with?('/*', '*/')
  end

  def line_has_todo(is_multi_line_comment, line)
    if is_multi_line_comment
      line.include?('TODO:')
    else
      line.start_with?('//') && line.include?('TODO:')
    end
  end

  def todo_file_paths
    file_paths.select do |file|
      data_in_lines = File.readlines(file)
      multi_line_comment = false
      valid_lines = data_in_lines.select do |line|
        multi_line_comment = !multi_line_comment if multi_line_comment?(line)
        line_has_todo(multi_line_comment, line)
      end

      valid_lines.length.positive?
    end
  end
end

new_directory = DirectoryReader.new('test_dir')
puts new_directory.todo_file_paths
