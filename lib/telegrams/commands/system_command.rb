require_relative '../respondable_telegram'

class SystemCommand < RespondableTelegram
  def initialize(response_required=true)
    super
    @type = 0x01
  end
end
