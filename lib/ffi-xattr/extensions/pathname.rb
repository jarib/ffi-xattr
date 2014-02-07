require 'ffi-xattr/extensions/file'

class Pathname
  # Returns an Xattr object.
  # See File.xattr.
  def xattr
    File.xattr(self)
  end
end
