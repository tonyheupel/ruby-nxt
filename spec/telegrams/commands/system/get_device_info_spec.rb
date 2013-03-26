require './spec/helper'
require './lib/telegrams/commands/system/get_device_info'

describe GetDeviceInfo do
  it "must not accept a require_response override" do
    -> { GetDeviceInfo.new false }.must_raise ArgumentError
  end

  it "must require a response" do
    GetDeviceInfo.new.require_response?.must_equal true
  end

  it "must have a command of 0x9B" do
    GetDeviceInfo.new.command.must_equal 0x9B
  end
end
