require 'minitest/autorun'

require_relative '../../lib/communication/bluetooth_communication.rb'

class BluetoothCommunication
  attr_accessor :profile
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
      @mock_profile.expect(:send_data_package, nil, [[3,0,0,1,2]])

      @communication.send(message)

      message.verify
      @mock_profile.verify
    end
  end
end
