require_relative "../respondable_telegram"

class DirectCommand < RespondableTelegram
  def initialize(response_required=false)
    @type = 0x00
  end
end
