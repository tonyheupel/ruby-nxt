require_relative './serial_port_profile'

class BluetoothCommunication
  def initialize(device, serial_port_profile=nil)
    raise ArgumentError, "device must be non-nil" if device.nil?

    @profile = serial_port_profile || SerialPortProfile.new(device)
  end
end
