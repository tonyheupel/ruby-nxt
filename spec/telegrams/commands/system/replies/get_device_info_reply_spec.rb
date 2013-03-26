require './spec/helper'
require './lib/telegrams/commands/system/replies/get_device_info_reply'

def get_msb_and_lsb(number)
  lsb = number & 0xff
  msb = (number >> 8) & 0xff
  { :msb => msb, :lsb => lsb }
end

describe GetDeviceInfoReply do
  before do
    reply_to_command_status_bytes = [0x02, 0x9B, 0x00]
    @nxt_brick_name = "MyNXTBrick"
    nxt_brick_name_bytes = @nxt_brick_name.ljust(15, "\0").unpack("C*")
    @bt_address = "\x01\x02\x03\x04\x05\x06\x00"
    bt_address_bytes = @bt_address.unpack('C*')
    @signal_strength = 100
    signal_strength_hash = get_msb_and_lsb(@signal_strength)

    @free_user_flash_memory = 512  # 0.5 KB
    free_user_flash_memory_hash = get_msb_and_lsb(@free_user_flash_memory)

    @reply_bytes = reply_to_command_status_bytes # 0-2
    @reply_bytes = @reply_bytes.concat nxt_brick_name_bytes # 3-17
    @reply_bytes = @reply_bytes.concat bt_address_bytes # 18-24
    @reply_bytes = @reply_bytes << signal_strength_hash[:lsb] # 25
    @reply_bytes = @reply_bytes.concat [0x00, 0x00] # 26-27 more lsb's
    @reply_bytes = @reply_bytes << signal_strength_hash[:msb] # 28
    @reply_bytes = @reply_bytes << free_user_flash_memory_hash[:lsb] # 29
    @reply_bytes = @reply_bytes << free_user_flash_memory_hash[:msb]# 30
    @reply_bytes = @reply_bytes.concat [0x00, 0x00] # 31-32

    @reply = GetDeviceInfoReply.new(@reply_bytes)
  end

  describe "when constructing the get device info reply" do
    it "must raise an argument exception if the command is not get device user info" do
      @reply_bytes[1] = 0x00
      -> { GetDeviceInfoReply.new(@reply_bytes) }.must_raise ArgumentError
    end

    it "must be successful with successful reply" do
      @reply.success?.must_equal true
    end

    it "must set the nxt_brick_name" do
      @reply.nxt_brick_name.must_equal @nxt_brick_name
    end

    it "must set the Bluetooth Address bt_address property" do
      @reply.bt_address.must_equal "btspp://010203040506"
    end

    it "must set the signal_strength" do
      @reply.signal_strength.must_equal @signal_strength
    end

    it "must set the free_user_flash_memory_bytes" do
      @reply.free_user_flash_memory_bytes.must_equal @free_user_flash_memory
    end
  end

end
