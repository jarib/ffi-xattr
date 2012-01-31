class Xattr # :nodoc: all
  module Lib
    extend FFI::Library

    ffi_lib "c"

    attach_function :strerror, [:int], :string

    attach_function :listxattr,   [:string, :pointer, :size_t], :size_t
    attach_function :setxattr,    [:string, :string, :pointer, :size_t, :int], :int
    attach_function :getxattr,    [:string, :string, :pointer, :size_t], :int
    attach_function :removexattr, [:string, :string], :int

    attach_function :llistxattr,   [:string, :pointer, :size_t], :size_t
    attach_function :lsetxattr,    [:string, :string, :pointer, :size_t, :int], :int
    attach_function :lgetxattr,    [:string, :string, :pointer, :size_t], :int
    attach_function :lremovexattr, [:string, :string], :int

    class << self
      def list(path, no_follow)
        method = no_follow ? :llistxattr : :listxattr
        size = send(method, path, nil, 0)
        res_ptr = FFI::MemoryPointer.new(:pointer, size)
        send(method, path, res_ptr, size)

        res_ptr.read_string(size).split("\000")
      end

      def get(path, no_follow, key)
        method = no_follow ? :lgetxattr : :getxattr
        size = send(method, path, key, nil, 0)
        return unless size > 0

        str_ptr = FFI::MemoryPointer.new(:char, size)
        send(method, path, key, str_ptr, size)

        str_ptr.read_string(size)
      end

      def set(path, no_follow, key, value)
        method = no_follow ? :lsetxattr : :setxattr
        Error.check send(method, path, key, value, value.bytesize, 0)
      end

      def remove(path, no_follow, key)
        method = no_follow ? :lremovexattr : :removexattr
        Error.check send(method, path, key)
      end
    end

  end
end
