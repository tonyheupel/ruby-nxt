require './spec/helper'

require './lib/communication/bluetooth_communication'
require './lib/telegrams/reply'

class BluetoothCommunication
  attr_accessor :profile
end


class ReceiveMessageLength3BluetoothCommunication < BluetoothCommunication
  def read_length_of_received_message!
    3
  end
end

describe BluetoothCommunication do
  describe "when creating a new bluetooth communication object" do
    it "must raise an ArgumentError if device is not set" do
      -> { BluetoothCommunication.new }.must_raise ArgumentError
    end

    it "must raise an ArgumentError if device is nil" do
      -> { BluetoothCommunication.new(nil, Object.new) }.must_raise ArgumentError
    end

    it "must default to using a SerialPortProfile for its profile" do
      BluetoothCommunication.new('dev').profile.must_be_instance_of SerialPortProfile
    end

    it "must use the profile passed in if provided" do
      fake_profile = Object.new
      BluetoothCommunication.new('dev', fake_profile).profile.must_be(:==, fake_profile)
    end
  end

  describe "when connecting over bluetooth" do
    it "should use connect using the serial profile" do
      mock_profile = MiniTest::Mock.new.expect(:connect, nil)
      BluetoothCommunication.new('dev', mock_profile).connect

      mock_profile.verify
    end

    it "should disconnect using the serial profile" do
      mock_profile = MiniTest::Mock.new.expect(:disconnect, nil)
      BluetoothCommunication.new('dev', mock_profile).disconnect

      mock_profile.verify
    end
  end

  describe "when sending a message over bluetooth" do
    before do
      @mock_profile = MiniTest::Mock.new
      @communication = BluetoothCommunication.new('dev', @mock_profile)
    end


    it "must call as_bytes on the telegram being passed in" do
      message = MiniTest::Mock.new.expect(:as_bytes, [0,1,2])
      message.expect(:require_response?, false) # don't do anything after send
      @mock_profile.expect(:send_data_package, nil, [[3,0,0,1,2]])

      @communication.send_message(message)

      message.verify
      @mock_profile.verify
    end

    describe "when expecting a response" do
      before do
        @fake_command = MiniTest::Mock.new.expect(:require_response?, true)
        @fake_command.expect(:as_bytes, [0x00, 0x01, 0x00])

        @mock_profile.expect(:send_data_package, nil, [[3,0,0,1,0]])
        @mock_profile.expect(:receive_data_package, "\x03\x00\x02\x01\x00")
      end

      it "must call receive_message and return the response if a response is required" do
        @communication.send_message(@fake_command).must_equal [2,1,0]
      end

      it "must yield to the passed in block if a response is required" do
        @communication.send_message(@fake_command) do | response |
          response[0].must_equal 2
          response[1].must_equal 1
          response[2].must_equal 0
        end
      end

      it "must create a new instance of the class specified as the return type" do
        reply = @communication.send_message(@fake_command, Reply)
        reply.type.must_equal 0x02
        reply.command.must_equal 0x01
        reply.success?.must_equal true
      end

      it "must pass an instance of the reply class to the passed in block if a response is required" do
        @communication.send_message(@fake_command, Reply) do | reply |
          reply.type.must_equal 2
          reply.command.must_equal 1
          reply.status.must_equal 0
          reply.success?.must_equal true
        end
      end
    end

    describe "when not expecting a response" do
      before do
        @fake_command = MiniTest::Mock.new.expect(:require_response?, false)
        @fake_command.expect(:as_bytes, [0x00, 0x01, 0x00])

        @mock_profile.expect(:send_data_package, nil, [[3,0,0,1,0]])
        # do not expect receive_data_package
      end

      it "must not call receive_message and do not return a response" do
        @communication.send_message(@fake_command).must_equal nil
      end


      it "must not yield to the passed in block when a response is not wanted" do
        @communication.send_message(@fake_command) do | response |
          raise "Should not call this block!"
        end
      end

      describe "but passing in a reply class to use" do
        it "must not call receive_message and do not return a response" do
          @communication.send_message(@fake_command, Reply).must_equal nil
        end
      end
    end
  end

  describe "when receiving a message over bluetooth" do

    before do
      @mock_profile = MiniTest::Mock.new
      @communication = BluetoothCommunication.new('dev', @mock_profile)
    end

    describe "when getting the raw bytes from the profile" do
      it "must call receive_data_package on the profile" do
        @mock_profile.expect(:receive_data_package, [0x02, 0x11, 0x00])
      end
    end

    describe "when using read_length_of_received_message! private method" do

      it "must use sysread to get the length of the message" do
        # first two bytes are the bluetooth header that has the
        # message length as a 16-bit Little Endian number
        raw_message = "\x03\x00\x02\x01\x00"
        @mock_profile.expect(:receive_data_package, raw_message)

        message_parts = @communication.send(:split_message_into_header_and_message, raw_message)
        @communication.send(:get_length_of_received_message_from_bluetooth_header, message_parts[:header]).must_equal 3
      end
    end

    it "must retrun the raw bytes from the profile" do
      communication = ReceiveMessageLength3BluetoothCommunication.new('dev', @mock_profile)
      @mock_profile.expect(:receive_data_package, "\x03\x00\x02\x01\x00")

      communication.receive_message.must_equal [0x02, 0x01, 0x00]
    end
  end
end
