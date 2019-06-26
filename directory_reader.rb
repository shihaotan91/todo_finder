require "byebug"

class DirectoryReader
  attr_reader :directory

  def initialize(dir)
    path = "#{dir}/**/*"
    @directory = Dir[path]
    @comment_pattern_types = {
      '.js' => { 'single' => '//', 'multi' => ['/*', '*/'] },
      '.rb' => { 'single' => '#' }
    }
  end

  def file_paths
    @directory.select do |path|
      File.file? path
    end
  end

  def file_is_chosen_types
    file_types = @comment_pattern_types.keys
    file_types.include? @current_file_type
  end

  def line_has_commented_todo?(line, comment_pattern)
    if multi_line_comment?(line)
      line_has_todo(line)
    else
      line.start_with?(comment_pattern) && line.include?('TODO:')
    end
  end

  def multi_line_comment?(line)
    return false unless @current_file_type == '.js'
    multi_line_pattern = @comment_pattern_types['.js']['multi']
    @multi_line_comment = !@multi_line_comment if line.start_with?(*multi_line_pattern)

    @multi_line_comment
  end

  def line_has_todo(line)
    line.include?('TODO:')
  end

  def inspect_line(line, file)
    if file_is_chosen_types
      comment_pattern = @comment_pattern_types[@current_file_type]['single']
      line_has_commented_todo?(line, comment_pattern)
    else
      line_has_todo(line)
    end
  end

  def todo_file_paths
    file_paths.select do |file|
      @current_file_type = File.extname(file)
      @multi_line_comment = false

      data_in_lines = File.readlines(file)
      data_in_lines.find do |line|
        inspect_line(line, file)
      end
    end
  end
end

directory_reader = DirectoryReader.new('test_dir')
puts directory_reader.todo_file_paths
