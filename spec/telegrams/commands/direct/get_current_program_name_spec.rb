require './spec/helper'

require './lib/telegrams/commands/direct/get_current_program_name'

describe GetCurrentProgramName do
  describe "when constructing the object" do
    it "must not accept any parameters" do
      -> { GetCurrentProgramName.new false }.must_raise ArgumentError
    end

    it "must default to requiring a response since it is asking for one" do
      GetCurrentProgramName.new.require_response?.must_equal true
    end

    it "must have a command of 0x11 for getcurrentprogramname" do
      GetCurrentProgramName.new.command.must_equal 0x11
    end
  end

  describe "as_bytes" do
    it "must have the command as the second byte" do
      command = GetCurrentProgramName.new
      command.as_bytes[1].must_equal command.command
    end
  end
end
