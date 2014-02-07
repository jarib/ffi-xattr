require 'ffi-xattr'

class File
  
  # Returns an Xattr object for the named file (see Xattr).
  def self.xattr(file_name)
    Xattr.new(file_name)
  end
end
