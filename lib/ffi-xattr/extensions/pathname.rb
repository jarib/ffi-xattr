require 'ffi-xattr/extensions/file'

class Pathname
  def xattr
    File.xattr(self)
  end
end
