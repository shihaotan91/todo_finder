class DirectoryReader
  def initialize(path)
    path = "#{path}/**/*"
    directory = Dir[path]
  end
end

DirectoryReader.new('test_dir')