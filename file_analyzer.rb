class FileAnalyzer
  attr_accessor :current_file_type, :multi_line_comment

  def initialize(file)
    @file = file
    @comment_patterns = {
      '.js' => { 'single' => '//', 'multi' => ['/*', '*/'] },
      '.rb' => { 'single' => '#' }
    }
  end

  def todo_present?
    lines_in_file = File.readlines(@file)
    @current_file_type = File.extname(@file)
    @multi_line_comment = false

    lines_in_file.find do |line|
      inspect_line(line)
    end
  end

  def file_is_chosen_types
    file_types = @comment_patterns.keys
    file_types.include? @current_file_type
  end

  def close_multi_comment(line)
    return unless @current_file_type == '.js'
    @multi_line_comment = false if line.end_with?("*/\n")
  end

  def line_has_commented_todo?(line, comment_pattern)
    if in_multi_line_comment?(line)
      line_has_todo?(line)
    else
      line.start_with?(comment_pattern) && line_has_todo?(line)
    end
  end

  def in_multi_line_comment?(line)
    return false unless @current_file_type == '.js'
    multi_line_pattern = @comment_patterns['.js']['multi']
    @multi_line_comment = !@multi_line_comment if line.start_with?(*multi_line_pattern)

    @multi_line_comment
  end

  def line_has_todo?(line)
    line.include?('TODO:')
  end

  def inspect_line(line)
    has_todo = if file_is_chosen_types
                 comment_pattern = @comment_patterns[@current_file_type]['single']
                 line_has_commented_todo?(line, comment_pattern)
               else
                 line_has_todo?(line)
               end

    close_multi_comment(line)

    has_todo
  end
end
