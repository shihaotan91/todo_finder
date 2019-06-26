require "byebug"

class DirectoryReader
  attr_reader :directory

  def initialize(dir)
    path = "#{dir}/**/*"
    @directory = Dir[path]
    @comment_pattern_types = {
      '.js' => '//',
      '.rb' => '#'
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
    line.start_with?(comment_pattern) && line.include?('TODO:')
  end

  # def multi_line_comment?(line)
  #   line.start_with?('/*', '*/')
  # end

  def line_has_todo(line, file)
    if file_is_chosen_types
      line_has_commented_todo?(line, @comment_pattern_types[@current_file_type])
    else
      line.include?('TODO:')
    end
    # if is_multi_line_comment
    #   line.include?('TODO:')
    # else
    #   line.start_with?('//') && line.include?('TODO:')
    # end
  end

  def todo_file_paths
    file_paths.select do |file|
      @current_file_type = File.extname(file)
      data_in_lines = File.readlines(file)
      # multi_line_comment = false
      data_in_lines.find do |line|
        line_has_todo(line, file)
      end
    end
  end
end

directory_reader = DirectoryReader.new('test_dir')
puts directory_reader.todo_file_paths
