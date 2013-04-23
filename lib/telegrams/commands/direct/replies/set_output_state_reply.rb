require_relative '../../direct_command_reply'

class SetOutputStateReply < DirectCommandReply
	def initialize(bytes)
		super(bytes)
	end

  def validate_bytes(bytes)
    raise ArgumentError, "must be a reply for a SetOutputState command" unless bytes[1] == 0x04
  end
end
