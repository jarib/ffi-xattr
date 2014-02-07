require 'ffi-xattr'

class File
  def self.xattr(path)
    Xattr.new(path)
  end
end
