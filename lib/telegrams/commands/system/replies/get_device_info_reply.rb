require_relative '../../../reply'

class GetDeviceInfoReply < Reply
  attr_reader :nxt_brick_name, :bt_address, 
              :signal_strength, :free_user_flash_memory_bytes

  def initialize(bytes)
    super
    raise ArgumentError, "must be a GetDeviceInfoReply (0x9B)" unless bytes[1] == 0x9B

    @nxt_brick_name = parse_brick_name(bytes)
    @bt_address = parse_bt_address(bytes)
    @signal_strength = parse_signal_strength(bytes)
    @free_user_flash_memory_bytes = parse_free_user_flash_memory(bytes)
  end

  private
  def parse_brick_name(bytes)
    bytes[3..17].pack("C*").strip
  end

  def parse_bt_address(bytes)
    # skip the null terminator, so 18-23 with 24 at null terminator
    address = bytes[18..23].map { | byte | byte.to_s(8).rjust(2, "0") }
    "btspp://#{address.join('')}"
  end

  def parse_signal_strength(bytes)
    signal_strength_bytes = bytes[25..28]
    convert_byte_array_of_little_endian_to_number(signal_strength_bytes)
  end

  def parse_free_user_flash_memory(bytes)
    free_memory_bytes = bytes[29..32]
    convert_byte_array_of_little_endian_to_number(free_memory_bytes)
  end

  def convert_byte_array_of_little_endian_to_number(byte_array)
    byte_array.pack('C*').unpack('v*')[0]
  end
end
