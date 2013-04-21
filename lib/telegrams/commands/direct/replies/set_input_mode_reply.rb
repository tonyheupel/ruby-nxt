require_relative '../../direct_command_reply'

class SetInputModeReply < DirectCommandReply
	def initialize(bytes)
		super(bytes)
	end

  def validate_bytes(bytes)
    raise ArgumentError, "must be a reply for a SetInputMode command" unless bytes[1] == 0x05
  end
end