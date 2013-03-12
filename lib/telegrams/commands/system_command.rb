class SystemCommand < RespondableTelegram
  def initialize(response_required=false)
    @type = 0x01
  end
end
