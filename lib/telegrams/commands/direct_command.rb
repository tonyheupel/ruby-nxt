require_relative "../respondable_telegram"

class DirectCommand < RespondableTelegram
  def initialize(require_response=true)
    super
    @type = 0x00
  end
end
