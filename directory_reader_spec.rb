require_relative "directory_reader"
require "test/unit"
require "byebug"

class DirectoryReaderTest < Test::Unit::TestCase
  def test_files_with_todos
    path = 'test_dir'
    directory = DirectoryReader.new("#{path}/**/*")
    paths_with_todos = ['test_dir/dir3/test5.js', 'test_dir/dir1/test1.js']
    assert_equal(paths_with_todos, directory.todo_file_paths)
  end
end
