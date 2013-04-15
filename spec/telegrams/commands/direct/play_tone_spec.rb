require './spec/helper'
require './lib/telegrams/commands/direct/play_tone'

describe PlayTone do
  describe "when constructing the command" do
    before do
      @command = PlayTone.new(200, 100)
    end

    it "must be a direct command" do
      @command.type.must_equal DirectCommand.new.type
    end

    it "must have a command of 0x03" do
      @command.command.must_equal 0x03
    end

    it "must require a response by default" do
      @command.require_response?.must_equal true
    end

    it "must throw an ArgumentException if the frequency is not passed in" do
      -> { PlayTone.new }.must_raise ArgumentError
    end

    it "must throw an ArgumentException if the duration is not passed in" do
      -> { PlayTone.new(500) }.must_raise ArgumentError
    end

    it "must set the frequency to what is passed in" do
      PlayTone.new(500, 100).frequency.must_equal 500
    end

    it "must set the duration to what is passed in" do
      PlayTone.new(500, 100).duration.must_equal 100
    end

    it "must validate that the frequency (in Hz) is between 200 and 14000 Hz (the valid range)" do
      -> { PlayTone.new(199, 100) }.must_raise ArgumentError
      -> { PlayTone.new(14001, 100) }.must_raise ArgumentError
    end

    it "must validate that the duration (in ms) is positive or zero" do
      -> { PlayTone.new(500, -1) }.must_raise ArgumentError
      PlayTone.new(500, 0)
    end
  end

  describe "when rendering the command as bytes" do
    it "must set byte 1 to 0x03 as the playtone command" do
      PlayTone.new(500, 1).as_bytes[1].must_equal 0x03
    end

    it "must set bytes 2-3 to a UWORD of the frequency to play in reverse order" do
      PlayTone.new(500, 1).as_bytes[2..3].must_equal [0xf4, 0x01]
    end

    it "must set bytes 4-5 to a UWORD of the duration to play the tone" do
      PlayTone.new(500, 2000).as_bytes[4..5].must_equal [0xd0, 0x07]
    end
  end
end

