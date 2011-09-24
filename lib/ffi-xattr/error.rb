class Xattr
  module Error
    extend FFI::Library

    ffi_lib "c"

    attach_function :strerror_r, [:int, :pointer, :size_t], :int

    def self.last
      ptr = FFI::MemoryPointer.new(:char, 256)
      strerror_r(FFI.errno, ptr, 256)

      ptr.read_string
    end

    def self.check(int)
      raise last if int != 0
    end
  end
end
