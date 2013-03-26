require_relative './reply'

class NoMessageReply < Reply
  # override to return empty string
  def message
    ''
  end
end


