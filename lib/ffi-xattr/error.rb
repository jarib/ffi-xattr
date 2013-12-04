class Xattr # :nodoc: all
  module Error
    extend FFI::Library

    ffi_lib "c"

    attach_function :strerror_r, [:int, :pointer, :size_t], :int unless RUBY_PLATFORM =~ /mingw/

    class << self
      def last
        ptr = FFI::MemoryPointer.new(:char, 256)
        strerror_r(FFI.errno, ptr, 256)

        ptr.read_string
      end

      def check(int)
        raise last if int != 0
      end
    end
  end
end
