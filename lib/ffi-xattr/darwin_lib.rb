class Xattr # :nodoc: all
  module Lib
    extend FFI::Library

    ffi_lib "System"

    attach_function :listxattr,   [:string, :pointer, :size_t, :int], :ssize_t
    attach_function :getxattr,    [:string, :string, :pointer, :size_t, :uint, :int], :ssize_t
    attach_function :setxattr,    [:string, :string, :pointer, :size_t, :uint, :int], :int
    attach_function :removexattr, [:string, :string, :int], :int

    XATTR_NOFOLLOW = 0x0001

    class << self
      def list(path, no_follow)
        options = no_follow ? XATTR_NOFOLLOW : 0
        size = listxattr(path, nil, 0, options)
        res_ptr = FFI::MemoryPointer.new(:pointer, size)
        listxattr(path, res_ptr, size, options)

        res_ptr.read_string(size).split("\000")
      end

      def get(path, no_follow, key)
        options = no_follow ? XATTR_NOFOLLOW : 0
        size = getxattr(path, key, nil, 0, 0, options)
        return unless size > 0

        str_ptr = FFI::MemoryPointer.new(:char, size)
        getxattr(path, key, str_ptr, size, 0, options)

        str_ptr.read_string(size)
      end

      def set(path, no_follow, key, value)
        options = no_follow ? XATTR_NOFOLLOW : 0
        Error.check setxattr(path, key, value, value.bytesize, 0, options)
      end

      def remove(path, no_follow, key)
        options = no_follow ? XATTR_NOFOLLOW : 0
        Error.check removexattr(path, key, options)
      end
    end

  end
end
