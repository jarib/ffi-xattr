class Xattr
  module Lib
    extend FFI::Library

    ffi_lib "c"

    attach_function :strerror, [:int], :string

    attach_function :listxattr,   [:string, :pointer, :size_t], :size_t
    attach_function :setxattr,    [:string, :string, :pointer, :size_t, :int], :int
    attach_function :getxattr,    [:string, :string, :pointer, :size_t], :int
    attach_function :removexattr, [:string, :string], :int

    def self.list(path)
      size = listxattr(path, nil, 0)
      res_ptr = FFI::MemoryPointer.new(:pointer, size)
      listxattr(path, res_ptr, size)

      res_ptr.read_string(size).split("\000")
    end

    def self.get(path, key)
      size = getxattr(path, key, nil, 0)
      return unless size > 0

      str_ptr = FFI::MemoryPointer.new(:char, size);
      getxattr(path, key, str_ptr, size)

      str_ptr.read_string
    end

    def self.set(path, key, value)
      Error.check setxattr(path, key, value, value.bytesize, 0)
    end

    def self.remove(path, key)
      Error.check removexattr(path, key.to_s)
    end

  end
end