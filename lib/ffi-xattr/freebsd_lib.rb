class Xattr # :nodoc: all
  module Lib
    extend FFI::Library

    ffi_lib "c"

    EXTATTR_NAMESPACE_USER = 1

    attach_function :extattr_list_file,   [:string, :int, :pointer, :size_t], :ssize_t
    attach_function :extattr_set_file,    [:string, :int, :string, :pointer, :size_t], :ssize_t
    attach_function :extattr_get_file,    [:string, :int, :string, :pointer, :size_t], :ssize_t
    attach_function :extattr_delete_file, [:string, :int, :string], :ssize_t

    attach_function :extattr_list_link,   [:string, :int, :pointer, :size_t], :ssize_t
    attach_function :extattr_set_link,    [:string, :int, :string, :pointer, :size_t], :ssize_t
    attach_function :extattr_get_link,    [:string, :int, :string, :pointer, :size_t], :ssize_t
    attach_function :extattr_delete_link, [:string, :int, :string], :ssize_t

    class << self
      def list(path, no_follow)
        method = no_follow ? :extattr_list_link : :extattr_list_file
        size = send(method, path, EXTATTR_NAMESPACE_USER, nil, 0)
        res_ptr = FFI::MemoryPointer.new(:pointer, size)
        send(method, path, EXTATTR_NAMESPACE_USER, res_ptr, size)

        res = []
        bytes = res_ptr.read_string(size).bytes
        until bytes.empty?
          size = bytes.shift
          res << bytes.shift(size).map(&:chr).join
        end

        res
      end

      def get(path, no_follow, key)
        method = no_follow ? :extattr_get_link : :extattr_get_file
        size = send(method, path, EXTATTR_NAMESPACE_USER, key, nil, 0)
        return unless size > 0

        str_ptr = FFI::MemoryPointer.new(:char, size)
        send(method, path, EXTATTR_NAMESPACE_USER, key, str_ptr, size)

        str_ptr.read_string(size)
      end

      def set(path, no_follow, key, value)
        method = no_follow ? :extattr_set_link : :extattr_set_file
        #require 'byebug'
        #byebug

        Error.check send(method, path, EXTATTR_NAMESPACE_USER, key, value, value.bytesize)
      end

      def remove(path, no_follow, key)
        method = no_follow ? :extattr_delete_link : :extattr_delete_file
        Error.check send(method, path, EXTATTR_NAMESPACE_USER, key)
      end
    end

  end
end
