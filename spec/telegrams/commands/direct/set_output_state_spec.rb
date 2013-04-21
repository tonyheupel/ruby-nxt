require './spec/helper'
require './lib/telegrams/commands/direct/set_output_state'

describe SetOutputState do
  describe 'when constructing the object' do
    it "must set the command to 0x04 for set_output_state" do
      SetOutputState.new(0,0,0,0,0,0,0).command.must_equal 0x04
    end
  end
end

describe OutputModeFlags do
  it "must have MOTORON set to 0x01" do
    OutputModeFlags.MOTORON.must_equal 0x01
  end

  it "must have BRAKE set to 0x02" do
    OutputModeFlags.BRAKE.must_equal 0x02
  end

  it "must have REGULATED set to 0x04" do
    OutputModeFlags.REGULATED.must_equal 0x04
  end

  it "must allow MOTORON and BRAKE to be combined into 0x03" do
    (OutputModeFlags.MOTORON | OutputModeFlags.BRAKE).must_equal 0x03
  end

  it "must allow MOTORON and REGULATED to be combined into 0x05" do
    (OutputModeFlags.MOTORON | OutputModeFlags.REGULATED).must_equal 0x05
  end

  it "must allow BRAKE and REGULATED to be combined into 0x06" do
    (OutputModeFlags.BRAKE | OutputModeFlags.REGULATED).must_equal 0x06
  end

  it "must allow all three to be combined into 0x07" do
    (OutputModeFlags.MOTORON | OutputModeFlags.BRAKE | OutputModeFlags.REGULATED).must_equal 0x07
  end
end


describe RegulationMode do
  it "must have IDLE defined as 0x00" do
    RegulationMode.IDLE.must_equal 0x00
  end

  it "must have MOTOR_SPEED defined as 0x01" do
    RegulationMode.MOTOR_SPEED.must_equal 0x01
  end

  it "must have MOTOR_SYNC defined as 0x02" do
    RegulationMode.MOTOR_SYNC.must_equal 0x02
  end
end


describe RunState do
  it "must have IDLE defined as 0x00" do
    RunState.IDLE.must_equal 0x00
  end

  it "must have RAMPUP defined as 0x10" do
    RunState.RAMPUP.must_equal 0x10
  end

  it "must have RUNNING defined as 0x20" do
    RunState.RUNNING.must_equal 0x20
  end

  it "must have RAMPDOWN defined as 0x40" do
    RunState.RAMPDOWN.must_equal 0x40
  end
end
