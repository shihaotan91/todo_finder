require './file_analyzer'
require 'test/unit'

Test::Unit.at_start do
  @@file_analyzer = FileAnalyzer.new('test')
end

class FileAnalyzerTest < Test::Unit::TestCase
  def test_file_is_chosen_types
    @@file_analyzer.current_file_type = '.js'
    assert_equal(true, @@file_analyzer.file_is_chosen_types)

    @@file_analyzer.current_file_type = '.rb'
    assert_equal(true, @@file_analyzer.file_is_chosen_types)

    @@file_analyzer.current_file_type = '.html'
    assert_equal(false, @@file_analyzer.file_is_chosen_types)
  end

  def test_close_multi_comment
    @@file_analyzer.current_file_type = '.js'
    @@file_analyzer.multi_line_comment = true

    @@file_analyzer.close_multi_comment('hello')
    assert_equal(true, @@file_analyzer.multi_line_comment)

    @@file_analyzer.current_file_type = '.rb'
    @@file_analyzer.close_multi_comment("*/\n")
    assert_equal(true, @@file_analyzer.multi_line_comment)

    @@file_analyzer.current_file_type = '.js'
    @@file_analyzer.close_multi_comment("*/\n")
    assert_equal(false, @@file_analyzer.multi_line_comment)
  end

  def test_line_has_todo?
    assert_equal(false, @@file_analyzer.line_has_todo?('blahblah'))
    assert_equal(true, @@file_analyzer.line_has_todo?('TODO:'))
  end

  def test_in_multi_line_comment?
    @@file_analyzer.current_file_type = '.rb'
    assert_equal(false, @@file_analyzer.in_multi_line_comment?("doesn't matter"))

    @@file_analyzer.current_file_type = '.js'
    assert_equal(false, @@file_analyzer.in_multi_line_comment?('hello world'))
    assert_equal(true, @@file_analyzer.in_multi_line_comment?('/*'))
    assert_equal(false, @@file_analyzer.in_multi_line_comment?('*/'))
  end

  def test_line_has_commented_todo
    @@file_analyzer.current_file_type = '.js'
    @@file_analyzer.multi_line_comment = false
    assert_equal(false, @@file_analyzer.line_has_commented_todo?('TODO:', '//'))
    assert_equal(true, @@file_analyzer.line_has_commented_todo?('// TODO:', '//'))

    @@file_analyzer.multi_line_comment = true
    assert_equal(true, @@file_analyzer.line_has_commented_todo?('TODO:', '//'))

    @@file_analyzer.current_file_type = '.rb'
    assert_equal(false, @@file_analyzer.line_has_commented_todo?('TODO:', '#'))
    assert_equal(true, @@file_analyzer.line_has_commented_todo?('# TODO:', '#'))
  end

  def test_inspect_line
    @@file_analyzer.current_file_type = '.html'
    assert_equal(true, @@file_analyzer.inspect_line('TODO:'))
    assert_equal(false, @@file_analyzer.inspect_line('DONTDO:'))

    @@file_analyzer.current_file_type = '.js'
    @@file_analyzer.multi_line_comment = false
    assert_equal(true, @@file_analyzer.inspect_line('// TODO:'))
    assert_equal(false, @@file_analyzer.inspect_line('// DONTDO:'))

    @@file_analyzer.current_file_type = '.rb'
    assert_equal(true, @@file_analyzer.inspect_line('# TODO:'))
    assert_equal(false, @@file_analyzer.inspect_line('# DONTDO:'))
  end

  def test_todo_present?
    dir = './test_dir'

    html_file_path = "#{dir}/html_dir/html_with_todo1.html"
    todo_html_analyzer = FileAnalyzer.new(html_file_path)
    assert_equal(false, todo_html_analyzer.todo_present?.nil?)

    js_file_path = "#{dir}/js_dir/js_without_todo2.js"
    without_todo_js_analyzer = FileAnalyzer.new(js_file_path)
    assert_equal(true, without_todo_js_analyzer.todo_present?.nil?)

    ruby_file_path = "#{dir}/ruby_dir/ruby_module1/ruby_with_todo1.rb"
    with_todo_ruby_analyzer = FileAnalyzer.new(ruby_file_path)
    assert_equal(false, with_todo_ruby_analyzer.todo_present?.nil?)
  end
end
