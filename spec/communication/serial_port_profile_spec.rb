require 'minitest/autorun'

require_relative '../../lib/communication/serial_port_profile.rb'

class FakeSerialPortConnection
#   attr_accessor :baud, :data_bits, :stop_bits, :parity,
#                 :flow_control, :read_timeout, :write_timeout
#
#   def initialize(port_num)
#     @port_num = port_num
#     @data_bits = 8
#     @stop_bits = 1
#     @parity = @data_bits == 8 ? SerialPort::NONE : SerialPort::EVEN
#   end
#
#   def get_modem_params
#     { 'baud' => baud,
#       'data_bits' => data_bits,
#       'stop_bits' => stop_bits,
#       'parity' => parity
#     }
#   end
#
#   def set_modem_params(baud, data_bits=nil, stop_bits=nil, parity=nil)
#     @baud = baud
#     @data_bits = data_bits unless data_bits.nil?
#     @stop_bits = stop_bits unless stop_bits.nil?
#     @parity = parity unless parity.nil?
#   end
#
#   def set_modem_params(hash)
#     set_modem_params(hash['baud'], hash['data_bits'], hash['stop_bits'], hash['parity'])
#   end
#
#   def modem_params
#     get_modem_params
#   end
#
#   def modem_params=(hash)
#     set_modem_params(hash)
#   end
#
#   def open
#     true
#   end
#
end

describe SerialPortProfile do
  describe "temporary tests" do
    before do
      @profile = SerialPortProfile.new('')
    end

    it "must have a send_data_package method" do
      @profile.must_respond_to :send_data_package
    end

    it "must have a receive_data_package method" do
      @profile.must_respond_to :receive_data_package
    end
  end

  describe "when creating a new instance" do
    it "must raise an ArgumentError if the device is nil" do
      -> { SerialPortProfile.new }.must_raise ArgumentError
    end

    it "must set the device if it is non-nil" do
      profile = SerialPortProfile.new('device')
      profile.instance_eval('@device').must_equal 'device'
    end

    it "must default the connection class to use to SerialPort" do
      profile = SerialPortProfile.new('')
      profile.instance_eval('@connection_class').must_equal(SerialPort)
    end

    it "must set the connection class if passed in and not nil" do
      profile = SerialPortProfile.new('', FakeSerialPortConnection)
      profile.instance_eval('@connection_class').must_equal(FakeSerialPortConnection)
    end
  end

  describe "when establishing the connection" do
    it "should set the modem settings as required" do
      mock_connection = MiniTest::Mock.new.expect(:nil?, false)
      mock_connection.expect(:flow_control=, nil, [SerialPort::HARD])
      mock_connection.expect(:read_timeout=, nil, [5000])

      mock_connection_class = MiniTest::Mock.new.expect(
        :new, mock_connection,
        [
          'dev',
          57600, # baud
          8,     # data_bits
          1,     # stop_bits
          SerialPort::NONE # parity
        ]
      )


      profile = SerialPortProfile.new('dev', mock_connection_class)

      profile.connect
      mock_connection_class.verify
    end
  end
end
