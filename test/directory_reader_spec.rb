require "./directory_reader"
require "test/unit"
require "byebug"

Test::Unit.at_start do
  @@test_directory = './test_dir/**/*'
  @@directory_reader = DirectoryReader.new('test_dir')
end

class DirectoryReaderTest < Test::Unit::TestCase
  def test_directory
    all_files_and_dirs_path = Dir[@@test_directory]
    assert_equal(all_files_and_dirs_path, @@directory_reader.directory)
  end

  def test_file_paths
    all_file_paths = Dir[@@test_directory].select do |path|
      File.file? path
    end
    assert_equal(all_file_paths, @@directory_reader.file_paths)
  end

  def test_todo_file_paths
    todo_file_paths = Dir[@@test_directory].select do |path|
      File.file?(path) && path.include?("with_todo")
    end
    assert_equal(todo_file_paths, @@directory_reader.todo_file_paths)
  end

  # def test_file_paths
  #   all_paths = ['test_dir/dir2/module2/test4.js',
  #                'test_dir/dir2/test2.js',
  #                'test_dir/dir3/test5.js',
  #                'test_dir/dir1/test1.js',
  #                'test_dir/dir1/module1/test3.js'].sort

  #   assert_equal(all_paths, @@directory_reader.file_paths.sort)
  # end

  # def test_multi_line_comment
  #   assert_equal(true, @@directory_reader.multi_line_comment?('/*'))
  #   assert_equal(true, @@directory_reader.multi_line_comment?('*/'))
  #   assert_equal(false, @@directory_reader.multi_line_comment?('/'))
  # end

  # def test_files_with_todos
  #   paths_with_todos = ['test_dir/dir3/test5.js', 'test_dir/dir1/test1.js'].sort
  #   assert_equal(paths_with_todos, @@directory_reader.todo_file_paths.sort)
  # end

  # def test_line_has_todo
  #   assert_equal(true, @@directory_reader.line_has_todo(true, 'TODO:'))
  #   assert_equal(false, @@directory_reader.line_has_todo(true, 'DONTDO:'))

  #   assert_equal(true, @@directory_reader.line_has_todo(false, '// TODO:'))
  #   assert_equal(false, @@directory_reader.line_has_todo(false, '// DONTDO:'))
  # end
end