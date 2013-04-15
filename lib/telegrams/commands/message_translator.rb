module MessageTranslator
  FILENAME_MAX_LENGTH = 20 # 15.3 + null terminator

  def string_as_bytes(string, max_length=FILENAME_MAX_LENGTH)
    # pad out to max length with null characters and then
    # convert all to ASCIIZ (null-terminated ascii string)
    string.ljust(max_length, "\0").unpack('C*')
  end

  def string_from_bytes(bytes)
    # convert from ASCIIZ (null-terminated ascii), removing all the 
    # trailing null characters
    bytes.pack("C*").strip
  end

  def add_default_extension_if_missing(filename, default_extension)
    /.+\.[A-Za-z0-9]{3}$/.match(filename).nil? ? "#{filename}.#{default_extension}" : filename
  end

  def boolean_as_bytes(boolean)
    boolean ? [0xff] : [0x00]
  end

  def boolean_from_bytes(bytes)
    bytes == [0x00] ? false : true
  end

  def integer_as_uword_bytes(integer)
   uword_byte_length = 4  # make sure number is 4 bytes, or 2, 2 digit hex values
   bytes_string = integer.to_s(16).rjust(uword_byte_length, "0")
   [bytes_string].pack('H*').bytes.to_a.reverse # reverse because it's MSB
  end

end
