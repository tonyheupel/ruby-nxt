require_relative "../respondable_telegram"

class DirectCommand < RespondableTelegram
  def initialize(response_required=true)
    super
    @type = 0x00
  end
end
