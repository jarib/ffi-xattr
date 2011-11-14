class Xattr
  module Lib
    extend FFI::Library

    ffi_lib "System"

    attach_function :listxattr,   [:string, :pointer, :size_t, :int], :ssize_t
    attach_function :getxattr,    [:string, :string, :pointer, :size_t, :uint, :int], :ssize_t
    attach_function :setxattr,    [:string, :string, :pointer, :size_t, :uint, :int], :int
    attach_function :removexattr, [:string, :string, :int], :int


    def self.list(path)
      size = listxattr(path, nil, 0, 0)
      res_ptr = FFI::MemoryPointer.new(:pointer, size)
      listxattr(path, res_ptr, size, 0)

      res_ptr.read_string(size).split("\000")
    end

    def self.get(path, key)
      size = getxattr(path, key, nil, 0, 0, 0)
      return unless size > 0

      str_ptr = FFI::MemoryPointer.new(:char, size);
      getxattr(path, key, str_ptr, size, 0, 0)

      str_ptr.read_string
    end

    def self.set(path, key, value)
      Error.check setxattr(path, key, value, value.bytesize, 0, 0)
    end

    def self.remove(path, key)
      Error.check removexattr(path, key, 0)
    end

  end
end
