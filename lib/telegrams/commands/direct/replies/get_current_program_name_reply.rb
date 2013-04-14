require_relative '../../direct_command_reply'
require_relative '../../message_translator'

class GetCurrentProgramNameReply < DirectCommandReply
  include MessageTranslator

  def initialize(bytes)
    super(bytes)
    @message = parse_message_bytes_into_filename
  end

  def message
    @message
  end

  def program_name
    message
  end

  private
  def validate_bytes(bytes)
    super(bytes)
    raise ArgumentError, "reply must be for a GetCurrentProgramName command" unless bytes[1] == 0x11
  end

  def parse_message_bytes_into_filename
    string_from_bytes(message_bytes)
  end

end
