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

  def send_message(message, reply_class=nil, &block)
    package = create_bluetooth_data_package(message)
    @profile.send_data_package(package)

    if message.require_response?
      response = receive_message

      response = reply_class.new(response) unless reply_class.nil?

      if block_given?
        yield response
      else
        response
      end
    end
  end

  def receive_message
    bluetooth_message = @profile.receive_data_package
    message_parts = split_message_into_header_and_message(bluetooth_message)
    convert_raw_received_message_to_bytes(message_parts[:message])
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

  def split_message_into_header_and_message(raw_message)
    { :header => raw_message[0..1],
      :message => raw_message[2..-1]
    }
  end

  def get_length_of_received_message_from_bluetooth_header(header)
    # note - this moves the @profile's current position
    #
    # This gets the length of the received data from the header that was sent
    # to us. We unpack it, as it's stored as a 16-bit Little Endian number.
    #
    # Reference: Appendix 1, Page 22
    header.unpack('v*')[0] # first element only
  end

  def convert_raw_received_message_to_bytes(raw_message)
    # 8-bit unsigned characters
    raw_message.unpack("C*")
  end

end
