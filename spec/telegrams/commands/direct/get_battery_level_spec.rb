require './spec/helper'
require './lib/telegrams/commands/direct/get_battery_level'

describe GetBatteryLevel do
  describe "when constructing the object" do
    it "must not accept any parameters" do
      -> { GetBatteryLevel.new false }.must_raise ArgumentError
    end

    it "must default to requiring a response since it is asking for one" do
      GetBatteryLevel.new.require_response?.must_equal true
    end

    it "must have a command of 0x0B for getbatterylevel" do
      GetBatteryLevel.new.command.must_equal 0x0B
    end
  end

  describe "as_bytes" do
    it "must have the command as the second byte" do
      command = GetBatteryLevel.new
      command.as_bytes[1].must_equal command.command
    end
  end

end
