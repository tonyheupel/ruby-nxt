require 'minitest/autorun'

require_relative '../../lib/communication/serial_port_profile.rb'

class FakeSerialPortConnection; end

# Open up SerialPortProfile to be able to set the connection
class SerialPortProfile
  def connection=(value)
    @connection = value
  end
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

  describe "when closing the connection" do
    before do
      @mock_connection = MiniTest::Mock.new
      @mock_connection_class = MiniTest::Mock.new.expect(:new, @mock_connection,
        ['dev', 57600, 8, 1, SerialPort::NONE]
      )
      @mock_connection.expect(:close, nil)

      @profile = SerialPortProfile.new('dev', @mock_connection_class);
    end

    it "should not call close if there is no connection object" do
      @mock_connection.expect(:nil?, true)
      @profile.connection = @mock_connection

      @profile.disconnect

      # Assert that MockExpectationError was raised because close was not called
      # We dont' want close to be called, ensure that the MockExpectationError for
      # close IS IN FACT raised.
      assert_raises(MockExpectationError, "close should be called") do
        @mock_connection.verify
      end
    end

    it "should not call close if there is a connection object but it is already closed" do
      @mock_connection.expect(:nil?, false)
      @mock_connection.expect(:closed?, true)
      @profile.connection = @mock_connection

      @profile.disconnect

      # Assert that MockExpectationError was raised because close was not called
      # We dont' want close to be called, ensure that the MockExpectationError for
      # close IS IN FACT raised.
      assert_raises(MockExpectationError, "close should be called") do
        @mock_connection.verify
      end
    end

    it "should call close if there is an open connection" do
      @mock_connection.expect(:nil?, false)
      @mock_connection.expect(:closed?, false)
      @profile.connection = @mock_connection

      @profile.disconnect

      @mock_connection.verify
    end
  end
end
