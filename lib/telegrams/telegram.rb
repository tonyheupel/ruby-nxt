class Telegram
  attr_reader :type

  def initialize()
  end

  def as_bytes
    [@type]
  end

  def max_size_in_bytes
    64
  end
end
