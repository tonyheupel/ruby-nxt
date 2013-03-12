require 'minitest/autorun'

require_relative '../../lib/telegrams/telegram'

describe Telegram do
  before do
    @telegram = Telegram.new
  end

  describe "when accessing the type property" do
    before do
      @type_value = 0x77
      @telegram.instance_eval("@type = #{@type_value}")
    end

    it "allows read access" do
      @telegram.type.must_equal @type_value
    end

    it "does not allow write access" do
      -> { @telegram.type = "biz buzz" }.must_raise(NoMethodError)
      @telegram.type.must_equal @type_value
    end
  end



end
