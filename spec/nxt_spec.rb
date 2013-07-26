require './spec/helper'
require './lib/nxt'

class TestableNXT < NXT
  attr_reader :command, :reply_type

  def initialize(device_path, communication=nil)
    super(device_path, communication)
  end

  def send_message(command, reply_type=nil)
    @command = command
    @reply_type = reply_type
    super(command, reply_type)
  end
end

describe NXT do
  describe "when constructing an instance" do
    it "must raise an ArgumentError if there is no device path" do
      -> { NXT.new }.must_raise ArgumentError
    end

    it "must raise an ArgumentError if there is a nil device path" do
      -> { NXT.new(nil) }.must_raise ArgumentError
    end

    it "must accept a device path and set it" do
      NXT.new('/dev/tty.NXT-DevB').device_path.must_equal '/dev/tty.NXT-DevB'
    end

    it "must default to a communication object of BluetoothCommunication" do
      NXT.new('some_device').communication.must_be_instance_of BluetoothCommunication
    end

    it "must accept a communication object and set it" do
      communication_object = Object.new
      NXT.new('some_device', communication_object).communication.must_be_same_as communication_object
    end
  end

  describe "when connecting to a device" do
    it "must call connect on the communication object" do
      mock_communication = MiniTest::Mock.new.expect(:connect, nil)
      NXT.new('some_device', mock_communication).connect
    end
  end

  describe "when disconnecting from a device" do
    it "must call disconnect on the communication object" do
      mock_communication = MiniTest::Mock.new.expect(:disconnect, nil)
      NXT.new('some_device', mock_communication).disconnect
    end
  end

  describe "when calling get_device_info" do
    before do
      @command = GetDeviceInfo.new
      @reply = GetDeviceInfoReply.new([0x02, 0x9B, 0x00, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, GetDeviceInfoReply])
      @nxt = NXT.new('device', @communication)
    end

    it "must call the communication object with a GetDeviceInfo command" do
      info = @nxt.get_device_info
    end

    it "must return the appropriate GetDeviceInfoReply object" do
      @nxt.get_device_info.must_be_same_as @reply
    end
  end

  describe "when calling stop_program" do
    before do
      @command = StopProgram.new
      @reply = StopProgramReply.new([0x02, 0x01, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, StopProgramReply])
      @nxt = NXT.new('device', @communication)
    end

    it "must call the communication object with a StopProgram command" do
      @nxt.stop_program
    end

      it "must return the appropriate StopProgramReply object when waiting for a reply" do
        @nxt.stop_program.must_be_same_as @reply
      end
  end

  describe "when calling start_program" do
    before do
      @command = StartProgram.new('program.rxe')
      @reply = StartProgramReply.new([0x02, 0x00, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, StartProgramReply])
      @nxt = TestableNXT.new('device', @communication)
    end

    it "must call the communication object with a StartProgram command" do
      @nxt.start_program('program.rxe')
      @nxt.command.must_be_instance_of StartProgram
      @nxt.command.name.must_equal "program.rxe"
    end

    it "must support not including the filename extension" do
      @nxt.start_program('program')
      @nxt.command.name.must_equal 'program.rxe'
    end

    it "must wait for a reply by default" do
      @nxt.start_program('program.rxe')
      @nxt.command.require_response?.must_equal true
    end


    it "must return the appropriate StartProgramReply object when waiting for a reply" do
      @nxt.start_program('program.rxe').must_be_same_as @reply
    end
  end


  describe "when calling stop_sound_playback" do
    before do
      @command = StopSoundPlayback.new
      @reply = StopSoundPlaybackReply.new([0x02, 0x0C, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, StopSoundPlaybackReply])
      @nxt = NXT.new('device', @communication)
    end

    it "must call the communication object with a StopSoundPlayback command" do
      @nxt.stop_sound_playback
    end

      it "must return the appropriate StopProgramReply object when waiting for a reply" do
        @nxt.stop_sound_playback.must_be_same_as @reply
      end
  end


  describe "when calling play_sound_file" do
    before do
      @command = PlaySoundFile.new('foobar.rso')
      @reply = PlaySoundFileReply.new([0x02, 0x02, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, PlaySoundFileReply])
      @nxt = TestableNXT.new('device', @communication)
    end

    it "must call the communication object with a PlaySoundFile command" do
      @nxt.play_sound_file('sound.mp3')
      @nxt.command.must_be_instance_of PlaySoundFile
      @nxt.command.name.must_equal "sound.mp3"
    end

    it "must wait for a reply by default" do
      @nxt.play_sound_file('sound.mp3')
      @nxt.command.require_response?.must_equal true
    end


    it "must return the appropriate PlaySoundFileReply object when waiting for a reply" do
      @nxt.play_sound_file('sound.mp3').must_be_same_as @reply
    end
  end


  describe "when calling get_current_program_name" do
    before do
      @command = GetCurrentProgramName.new
      # reply with a successful reply for GetCurrentProgramName with filename "foo.bar"
      @reply = GetCurrentProgramNameReply.new([0x02, 0x11, 0x00,
                                               102, 111, 111, 46, 98, 97, 114, 0,
                                               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, GetCurrentProgramNameReply])
      @nxt = NXT.new('device', @communication)
    end

    it "must call the communication object with a GetCurrentProgramName command" do
      @nxt.get_current_program_name
    end

      it "must return the appropriate GetCurrentProgramNameReply object when waiting for a reply" do
        @nxt.get_current_program_name.must_be_same_as @reply
      end

      it "must have the right filename as the message" do
        @nxt.get_current_program_name.program_name.must_equal "foo.bar"
      end
  end

  describe "when calling play_tone" do

    before do
      @command = PlayTone.new(400, 1000)
      @reply = PlayToneReply.new([0x02, 0x03, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, PlayToneReply])
      @nxt = TestableNXT.new('device', @communication)
    end

    it "must call the communication object with a PlayTone command" do
      @nxt.play_tone(400, 1000)
      @nxt.command.must_be_instance_of PlayTone
      @nxt.command.frequency.must_equal 400
      @nxt.command.duration.must_equal 1000
    end

    it "must wait for a reply by default" do
      @nxt.play_tone(400, 1000)
      @nxt.command.require_response?.must_equal true
    end

    it "must return the appropriate PlayToneReply object when waiting for a reply" do
      @nxt.play_tone(400, 1000).must_be_same_as @reply
    end
  end

  describe "when calling set_input_mode" do
    before do
      @command = SetInputMode.new(:three, :colorred, :booleanmode)
      @reply = SetInputModeReply.new([0x02, 0x05, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, SetInputModeReply])
      @nxt = TestableNXT.new('device', @communication)
    end

    it "must call the communication object with a SetInputMode command" do
      @nxt.set_input_mode(:three, :colorred, :booleanmode)
      @nxt.command.must_be_instance_of SetInputMode
      @nxt.command.input_port.must_equal :three
      @nxt.command.sensor_type.must_equal :colorred
      @nxt.command.sensor_mode.must_equal :booleanmode
    end

    it "must wait for a reply by default" do
      @nxt.set_input_mode(:three, :colorred, :booleanmode)
      @nxt.command.require_response?.must_equal true
    end


    it "must return the appropriate SetInputModeReply object when waiting for a reply" do
      @nxt.set_input_mode(:three, :colorred, :booleanmode).must_be_same_as @reply
    end
  end


  describe "when calling set_output_state" do
    before do
      @state = OutputState.new(:port => :c, :power => 55, :regulation_mode => :motor_sync)
      @command = SetOutputState.new(@state)
      @reply = SetOutputStateReply.new([0x02, 0x04, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, SetOutputStateReply])
      @nxt = TestableNXT.new('device', @communication)
    end

    it "must call the communication object with a SetOutputState command" do
      @nxt.set_output_state(@state)
      @nxt.command.must_be_instance_of SetOutputState
      @nxt.command.port.must_equal :c
      @nxt.command.power.must_equal 55
      @nxt.command.regulation_mode.must_equal :motor_sync
    end

    it "must wait for a reply by default" do
      @nxt.set_output_state(OutputState.new)
      @nxt.command.require_response?.must_equal true
    end


    it "must return the appropriate SetOutputStateReply object when waiting for a reply" do
      @nxt.set_output_state(OutputState.new).must_be_same_as @reply
    end
  end


  describe "when calling get_battery_level" do
    before do
      @command = GetBatteryLevel.new
      @reply = GetBatteryLevelReply.new([0x02, 0x0B, 0x00, 0x1B, 0x10])  # bytes at indexes 3-4 is the battery level in millivolts
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, GetBatteryLevelReply])
      @nxt = TestableNXT.new('device', @communication)
    end

    it "must send a GetBatteryLevel command " do
      @nxt.get_battery_level
      @nxt.command.must_be_instance_of GetBatteryLevel
    end

    it "must wait for a reply by default" do
      @nxt.get_battery_level
      @nxt.command.require_response?.must_equal true
    end

    it "must return the appropriate GetBatteryLevelReply object when waiting for a reply" do
      this_reply = @nxt.get_battery_level
      this_reply.must_be_same_as @reply
      this_reply.millivolts.must_equal 4123
      this_reply.volts.must_equal 4.123
    end
  end

  describe "when calling reset_motor_position" do
    before do
      @command = ResetMotorPosition.new
      @reply = ResetMotorPositionReply.new([0x02, 0x0A, 0x00])
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, ResetMotorPositionReply])
      @nxt = NXT.new('device', @communication)
    end

    it "must call the communication object with a ResetMotorPosition command" do
      @nxt.reset_motor_position
    end

      it "must return the appropriate ResetMotorPositionReply object when waiting for a reply" do
        @nxt.reset_motor_position.must_be_same_as @reply
      end
  end

  describe "when calling keep_alive" do
    before do
      @command = KeepAlive.new
      @reply = KeepAliveReply.new([0x02, 0x0D, 0x00, 0x15, 0xCD, 0x5B, 0x07])  # bytes at indexes 3-6 is the keep alive time in milliseconds
      @communication = MiniTest::Mock.new.expect(:send_message, @reply, [@command, KeepAliveReply])
      @nxt = TestableNXT.new('device', @communication)
    end

    it "must send a KeepAlive command " do
      @nxt.keep_alive
      @nxt.command.must_be_instance_of KeepAlive
    end

    it "must wait for a reply by default" do
      @nxt.keep_alive
      @nxt.command.require_response?.must_equal true
    end

    it "must return the appropriate KeepAliveReply object when waiting for a reply" do
      this_reply = @nxt.keep_alive
      this_reply.must_be_same_as @reply
      this_reply.milliseconds.must_equal 123_456_789
      this_reply.seconds.must_equal 123_456.789
    end
  end

  describe "yet-to-be implemented" do
    before do
      @nxt = TestableNXT.new('device')
    end

    it "must raise NotImplementedError for these methods" do
      [:get_output_state, :get_input_values, :reset_input_scaled_value,
       :message_write, :message_read,
       :ls_get_status, :ls_write, :ls_read].each do |method|
         -> { @nxt.send(method) }.must_raise NotImplementedError
       end
    end
  end


  describe "when calling async" do
    it "must be an instance of NXTAsync" do
      NXT.new('device_path').async.must_be_instance_of NXTAsync
    end

    it "must use the same communication and device_path as the parent" do
      communication = Object.new
      nxt = NXT.new('device_path', communication)
      nxt.async.device_path.must_equal nxt.device_path
      nxt.async.communication.must_equal nxt.communication
    end
  end
end


class MockCommunication
  def send_message(comamnd, reply_type)
  end
end

class NXTAsync
  attr_reader :command, :reply_type

  def send_message(command, reply_type=nil)
    super(command, reply_type)
    @command = command
    @reply_type = reply_type
  end
end

describe NXTAsync do
  before do
    @communication = MockCommunication.new
    @async = NXTAsync.new('device', @communication)
  end

  describe "constructor" do
    it "must send the device_path and communication object on" do
      @async.device_path.must_equal 'device'
      @async.communication.must_equal @communication
    end
  end

  describe "async" do
    it "must return itself when asked for async" do
      @async.async.must_equal @async
    end
  end

  describe "stop_program" do
    it "must send a StopProgram command without waiting for reply" do
      @async.stop_program
      @async.command.must_be_instance_of StopProgram
      @async.command.require_response?.must_equal false
    end
  end

  describe "start_program" do
    it "must send a StopProgram command without waiting for reply" do
      @async.start_program('program.rxe')
      @async.command.must_be_instance_of StartProgram
      @async.command.require_response?.must_equal false
    end
  end

  describe "stop_sound_playback" do
    it "must send a StopSoundPlayback command without waiting for reply" do
      @async.stop_sound_playback
      @async.command.must_be_instance_of StopSoundPlayback
      @async.command.require_response?.must_equal false
    end
  end

  describe "play_sound_file" do
    it "must send a PlaySoundFile command without waiting for reply" do
      @async.play_sound_file('sound.mp3')
      @async.command.must_be_instance_of PlaySoundFile
      @async.command.require_response?.must_equal false
    end
  end

  describe "play_tone" do
    it "must send a PlayTone command without waiting for reply" do
      @async.play_tone(400, 1000)
      @async.command.must_be_instance_of PlayTone
      @async.command.require_response?.must_equal false
    end
  end

  describe "set_output_state" do
    it "must send a SetOutputState command without waiting for a reply" do
      state = Object.new
      @async.set_output_state(state)
      @async.command.instance_eval('output_state').must_equal state
      @async.command.require_response?.must_equal false
    end
  end

  describe "reset_motor_position" do
    it "must send a ResetMotorPosition command without waiting for reply" do
      @async.reset_motor_position
      @async.command.must_be_instance_of ResetMotorPosition
      @async.command.require_response?.must_equal false
    end
  end

end
