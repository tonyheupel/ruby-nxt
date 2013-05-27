require_relative '../../direct_command_reply'
require_relative '../../message_translator'

class GetBatteryLevelReply < DirectCommandReply
  include MessageTranslator

  def initialize(bytes)
    super
  end

  def message
    integer_from_bytes(message_bytes)
  end

  def millivolts
    message
  end

  def volts
    millivolts/1000.0
  end

  private
  def validate_bytes(bytes)
    super
    raise ArgumentError, "Must be a reply for GetBatteryLevel (0x0B)" unless bytes[1] == 0x0B
  end
end
