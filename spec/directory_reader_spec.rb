require './directory_reader'
require 'test/unit'

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
    end.sort
    assert_equal(all_file_paths, @@directory_reader.file_paths.sort)
  end

  def test_todo_file_paths
    todo_file_paths = Dir[@@test_directory].select do |path|
      File.file?(path) && path.include?('with_todo')
    end.sort
    assert_equal(todo_file_paths, @@directory_reader.todo_file_paths.sort)
  end
end