require './spec/helper'
require './lib/telegrams/commands/direct/output_state'

describe OutputState do
  # attr_reader :port, :power, :mode, :regulation_mode, :turn_ratio, :run_state, :tacho_limit

  # this next group can only be read from a GetOutputState call:
  #   tacho_count # internal count; number of counts since last reset of the motor counter
  #   block_tacho_count # current position relative to last programmed movement
  #   rotation_count # current position relative to last reset of the rotation sensor for this motor
  describe "when constructing the object" do
    it "must accept hash contructor arguments with defaults of 0" do
      state = OutputState.new({ :port => :a })
      state.port.must_equal :a
      state.mode_flags.must_equal 0
    end
  end

  describe "when using the builder structure" do
    before do
      @state = OutputState.new
    end

    it "must accept a 'for_port(port_symbol) message that sets the value and returns the object itself" do
      @state.for_port(:a).must_equal @state
      @state.port.must_equal :a
    end

    it "must accept a 'with_power(power)' message that sets the value and retuns the object itself" do
      @state.with_power(100).must_equal @state
      @state.power.must_equal 100
    end

    it "must accept a 'with_mode_flags(mode_flags)' that sets the value and retuns the object itself" do
      @state.with_mode_flags(OutputModeFlags.MOTORON | OutputModeFlags.REGULATED).must_equal @state
      @state.mode_flags.must_equal OutputModeFlags.MOTORON | OutputModeFlags.REGULATED
    end
  end

  describe "when using the setter methods" do
    before do
      @state = OutputState.new
    end

    it "must validate that the port is :a, :b, :c, or :all" do
      @state.port = :a
      @state.port = :b
      @state.port = :c
      @state.port = :all
      -> { @state.port = :d }.must_raise ArgumentError
    end

    it "must set the port when it is set" do
      @state.port = :b
      @state.port.must_equal :b
    end

    it "must validate that the power is between -100 and 100" do
      @state.power = -100
      @state.power = 0
      @state.power = 100
      -> { @state.power = -101 }.must_raise ArgumentError
      -> { @state.power = 101 }.must_raise ArgumentError
    end

    it "must vaidate that the mode_flags is a valid combination of 0 to all flags (0-7 as an integer)" do
      (0..7).each do |mode|
        @state.mode_flags = mode
        @state.mode_flags.must_equal mode
      end

      -> { @state.mode_flags = 8 }.must_raise ArgumentError
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
