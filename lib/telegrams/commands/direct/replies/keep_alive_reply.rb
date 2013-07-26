require_relative '../../direct_command_reply'
require_relative '../../message_translator'

class KeepAliveReply < DirectCommandReply
  include MessageTranslator

  def initialize(bytes)
    super
  end

  def message
    integer_from_bytes(message_bytes)
  end

  def milliseconds
    message
  end

  def seconds
    milliseconds / 1000.0
  end

  private
  def validate_bytes(bytes)
    super
    raise ArgumentError, "Must be a reply for KeepAlive (0x0D)" unless bytes[1] == 0x0D
  end
end
