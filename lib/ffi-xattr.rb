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
  include Enumerable

  # Create a new Xattr instance with path.
  # Use <tt>:no_follow => true</tt> in options to work on symlink itself instead of following it.
  def initialize(path, options = {})
    raise Errno::ENOENT, path unless File.exist?(path)
    @path = path.to_str
    @no_follow = !!options[:no_follow]
  end

  # List extended attribute names
  def list
    Lib.list @path, @no_follow
  end

  # Get an extended attribute value
  def get(key)
    Lib.get @path, @no_follow, key.to_s
  end
  alias_method :[], :get

  # Set an extended attribute value
  def set(key, value)
    Lib.set @path, @no_follow, key.to_s, value.to_s
  end
  alias_method :[]=, :set

  # Remove an extended attribute value
  def remove(key)
    Lib.remove @path, @no_follow, key.to_s
  end

  # Iterates over pairs of extended attribute names and values
  def each(&blk)
    list.each do |key|
      yield key, get(key)
    end
  end

  # Returns hash of extended attributes
  def as_json(*args)
    res = {}
    each { |k,v| res[k] = v }

    res
  end

end
