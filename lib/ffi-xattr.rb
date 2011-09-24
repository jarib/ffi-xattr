require 'ffi'
require 'ffi-xattr/version'
require 'ffi-xattr/error'

case RUBY_PLATFORM
when /linux/
  require 'ffi-xattr/linux_lib'
when /darwin|bsd/
  require 'ffi-xattr/darwin_lib'
else
  raise NotImplementedError, "ffi-xattr not supported on #{RUBY_PLATFORM}"
end

class Xattr
  def initialize(path)
    raise Errno::ENOENT, path unless File.exist?(path)
    @path = path
  end

  def list
    Lib.list @path
  end

  def get(key)
    Lib.get @path, key.to_s
  end
  alias_method :[], :get

  def set(key, value)
    Lib.set @path, key.to_s, value.to_s
  end
  alias_method :[]=, :set

  def remove(key)
    Lib.remove @path, key.to_s
  end

end


