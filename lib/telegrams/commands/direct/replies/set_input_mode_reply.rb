require_relative '../../direct_command_reply'

class SetInputModeReply < DirectCommandReply
	def initialize(bytes)
		super(bytes)
	end
end