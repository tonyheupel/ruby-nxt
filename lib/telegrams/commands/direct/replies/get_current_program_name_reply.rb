require_relative '../../direct_command_reply'
require_relative '../../message_translator'

class GetCurrentProgramNameReply < DirectCommandReply
  include MessageTranslator

  def initialize(bytes)
    super
    raise RuntimeError, "reply must be for 0x11, but was #{command}" unless command == 0x11
    @message = parse_message_bytes_into_filename
  end

  def message
    @message
  end

  def program_name
    message
  end

  private
  def parse_message_bytes_into_filename
    string_from_bytes(message_bytes)
  end

end
