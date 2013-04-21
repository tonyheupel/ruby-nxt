require './spec/helper'
require './lib/telegrams/commands/direct/set_input_mode'

describe SetInputMode do
    describe "when constructing the command" do
    before do
      @command = SetInputMode.new(:three, :colornone, :booleanmode)
    end

    it "must be a direct command" do
      @command.type.must_equal DirectCommand.new.type
    end

    it "must have a command of 0x05" do
      @command.command.must_equal 0x05
    end

    it "must require a response by default" do
      @command.require_response?.must_equal true
    end

    it "must throw an ArgumentException if the input_port is not passed in" do
      -> { SetInputMode.new }.must_raise ArgumentError
    end

    it "must throw an ArgumentException if the sensor_type is not passed in" do
      -> { SetInputMode.new(:one) }.must_raise ArgumentError
    end

    it "must throw an ArgumentException if the sensor_mode is not passed in" do
      -> { SetInputMode.new(:one, :colorred) }.must_raise ArgumentError
    end

    it "must set the input_port to what is passed in" do
      SetInputMode.new(:one, :colorblue, :booleanmode).input_port.must_equal :one
    end

    it "must set the sensor_type to what is passed in" do
      SetInputMode.new(:three, :colorgreen, :booleanmode).sensor_type.must_equal :colorgreen
    end

    it "must set the sensor_mode to what is passed in" do
      SetInputMode.new(:three, :colorgreen, :booleanmode).sensor_mode.must_equal :booleanmode
    end

    it "must validate that the input_port is valid (:one, :two, or :three)" do
      -> { SetInputMode.new(:five, :colorgreen, :booleanmode) }.must_raise ArgumentError
      -> { SetInputMode.new(:zero, :colorgreen, :booleanmode) }.must_raise ArgumentError
      SetInputMode.new(:one, :colorgreen, :booleanmode)
      SetInputMode.new(:two, :colorgreen, :booleanmode)
      SetInputMode.new(:three, :colorgreen, :booleanmode)
    end

    it "must validate the passed in sensor_type is valid" do
      -> { SetInputMode.new(:one, :foobar, :booleanmode) }.must_raise ArgumentError
      SetInputMode.new(:one, :colorfull, :booleanmode)
    end

    it "must validate the passed in sensor_mode is valid" do
      -> { SetInputMode.new(:one, :colorgreen, :foobarmode) }.must_raise ArgumentError
      SetInputMode.new(:one, :colorgreen, :booleanmode)
    end
  end

  describe "when getting the valid list of input ports" do
    describe "when accessing the class methods" do
      it "must return an array of symbols for input_ports" do
        SetInputMode.input_ports.must_equal [:one, :two, :three, :four]
      end

      it "must return an array of symbols for sensor_types" do
        SetInputMode.sensor_types.must_include :sound_db
      end

      it "must return an array of symbols for sensor_modes" do
        SetInputMode.sensor_modes.must_include :rawmode
      end

    end

    describe "when accessing the instance methods" do
      before do
        @command = SetInputMode.new(:one, :colornone, :booleanmode)
      end

      it "must return an array of symbols for input_ports" do
        @command.input_ports.must_equal [:one, :two, :three, :four]
      end

      it "must return an array of symbols for sensor_types" do
        @command.sensor_types.must_include :sound_db
      end

      it "must return an array of symbols for sensor_modes" do
        @command.sensor_modes.must_include :rawmode
      end

    end
  end
  describe "when rendering the command as bytes" do
    before do
      @command = SetInputMode.new(:three, :colorgreen, :booleanmode)
    end

    it "must set byte 1 to 0x05 as the SetInputMode command" do
      @command.as_bytes[1].must_equal 0x05
    end

    it "must set byte 2 to the input port value" do
      @command.as_bytes[2].must_equal 0x02
    end

    it "must set byte 3 to the sensor type value" do
      @command.as_bytes[3].must_equal 0x0F
    end

    it "must set byte 4 to the sensor mode value" do
      @command.as_bytes[4].must_equal 0x20
    end
  end

end