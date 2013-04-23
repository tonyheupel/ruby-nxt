require './spec/helper'
require './lib/telegrams/commands/direct/set_output_state'

describe SetOutputState do
  describe 'when constructing the object' do
    it "must set the command to 0x04 for set_output_state" do
      SetOutputState.new(OutputState.new).command.must_equal 0x04
    end

    it "must raise an ArgumentError when the output_state is nil" do
      -> { SetOutputState.new(nil) }.must_raise ArgumentError
    end

    it "must set the output_state member to what is passed in" do
      state = OutputState.new
      SetOutputState.new(state).instance_eval('output_state').must_equal state
    end
  end

  describe "when calling as_bytes" do
    before do
      @state = OutputState.new({
        :port => :b,
        :power => 50,
        :mode_flags => OutputModeFlags.MOTORON | OutputModeFlags.REGULATED,
        :regulation_mode => :motor_sync,
        :turn_ratio => -25,
        :run_state => :running,
        :tacho_limit => 39123
      })

      @command = SetOutputState.new @state
      @bytes = @command.as_bytes
    end

    it "must have the command type as the byte 0" do
      @bytes[0].must_equal 0x00
    end

    it "must have the proper command as the byte 1" do
      @bytes[1].must_equal 0x04
    end

    it "must have the output port as byte 2" do
      @bytes[2].must_equal 0x01
    end

    it "must have the power set point as byte 3" do
      @bytes[3].must_equal 50
    end

    it "must have the mode set as byte 4" do
      @bytes[4].must_equal 0x05 # (motoron and regulated)
    end

    it "must have the regulation mode set at byte 5" do
      @bytes[5].must_equal 0x02 # (motor_sync)
    end

    it "must have the turn ratio set at byte 6" do
      @bytes[6].must_equal -25
    end

    it "must have the run state set at byte 7" do
      @bytes[7].must_equal 0x20
    end

    it "must have the tacho limit set to bytes 8-12 in little endian" do
      @bytes[8..12].must_equal [211, 152, 0, 0]
    end
  end
end
