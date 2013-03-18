require 'minitest/autorun'

require_relative '../../lib/communication/bluetooth_communication.rb'

class BluetoothCommunication
  attr_accessor :profile
end

describe BluetoothCommunication do
  describe "when creating a new bluetooth communication object" do
    it "should raise an ArgumentError if device is not set" do
      -> { BluetoothCommunication.new }.must_raise ArgumentError
    end

    it "should raise an ArgumentError if device is nil" do
      -> { BluetoothCommunication.new(nil, Object.new) }.must_raise ArgumentError
    end

    it "should default to using a SerialPortProfile for its profile" do
      BluetoothCommunication.new('dev').profile.must_be_instance_of SerialPortProfile
    end
  end
end
