require_relative './telegram'

class Reply < Telegram
  def initialize
    @type = 0x02
  end
end
