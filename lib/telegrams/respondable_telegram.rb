require_relative './telegram'

class RespondableTelegram < Telegram
  attr_reader :command
  def initialize(require_response=true)
    @require_response = require_response
    @command = nil
  end

  def require_response?
    @require_response
  end

  def require_response=(value)
    @require_response = value
  end

  # override
  def as_bytes
    [adjust_type_for_require_response, command]
  end

  protected
  def adjust_type_for_require_response
    # if response is not required, mask the type
    # with 0x80 to say a response is not required
    @type | (require_response? ? 0x00 : 0x80)
  end
end
