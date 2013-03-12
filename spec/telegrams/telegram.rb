require 'minitest/autorun'

require_relative '../../lib/telegrams/telegram'

describe Telegram do
  before do
    @telegram = Telegram.new
    @type_value = 0x77
    @telegram.instance_eval("@type = #{@type_value}")
  end

  describe "when accessing the type property" do
    it "allows read access" do
      @telegram.type.must_equal @type_value
    end

    it "does not allow write access" do
      -> { @telegram.type = "biz buzz" }.must_raise NoMethodError
      @telegram.type.must_equal @type_value
    end
  end

  describe "when getting the telegram as bytes" do
    it "must return the type value as the first element of the array" do
      @telegram.as_bytes[0].must_equal @type_value
    end
  end


  describe "when working with a telegram" do
    it "specifies a maximum size of 64 bytes" do
      @telegram.max_size_in_bytes.must_equal 64
    end
  end



end
