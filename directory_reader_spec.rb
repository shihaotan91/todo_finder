require_relative "directory_reader"
require "test/unit"
require "byebug"

class DirectoryReaderTest < Test::Unit::TestCase
  def test_a
    path = 'test_dir'
    @@directory_reader = DirectoryReader.new("#{path}/**/*")
  end

  def test_files_with_todos
    paths_with_todos = ['test_dir/dir3/test5.js', 'test_dir/dir1/test1.js'].sort
    assert_equal(paths_with_todos, @@directory_reader.todo_file_paths.sort)
  end

  def test_all_file_paths
    all_paths = ['test_dir/dir2/module2/test4.js',
                 'test_dir/dir2/test2.js',
                 'test_dir/dir3/test5.js',
                 'test_dir/dir1/test1.js',
                 'test_dir/dir1/module1/test3.js'].sort

    assert_equal(all_paths, @@directory_reader.all_file_paths.sort)
  end

  def test_multi_line_comment
    assert_equal(true, @@directory_reader.multi_line_comment('/*'))
    assert_equal(true, @@directory_reader.multi_line_comment('/*'))
    assert_equal(false, @@directory_reader.multi_line_comment('-/-'))
  end
end
