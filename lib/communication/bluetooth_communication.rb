require_relative './serial_port_profile'

class BluetoothCommunication
  def initialize(device, serial_port_profile=nil)
    raise ArgumentError, "device must be non-nil" if device.nil?

    @profile = serial_port_profile || SerialPortProfile.new(device)
  end

  def connect
    @profile.connect
  end

  def disconnect
    @profile.disconnect
  end

  def send_message(message)
    # TODO: Determine whether to wait for response or not
    package = create_bluetooth_data_package(message)
    @profile.send_data_package(package)
  end


  private
  def create_bluetooth_data_package(message)
    bytes = message.as_bytes
    [calculate_length_lsb(bytes), calculate_length_msb(bytes)].concat(bytes)
  end

  def calculate_length_lsb(bytes)
    # Filter to only get the least significant byte's worth (and lose anything higher)
    bytes.length & 0xff
    # NOTE: Since the max message length is 64 bytes, the Least Significant Byte
    #       should always be the actual length since it fits in one byte
  end

  def calculate_length_msb(bytes)
    # Bit shift right by a byte, and then filter to only get one byte's worth
    (bytes.length >> 8) & 0xff
    # NOTE: Since the max message length is 64 bytes, the Most Significant Byte
    #       should always be zero since the length fits in one byte (LSB)
  end
end
