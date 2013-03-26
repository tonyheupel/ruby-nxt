require './spec/helper'

require './lib/telegrams/respondable_telegram'

class MockRespondableTelegram < RespondableTelegram
  def initialize(response_required=true)
    super
    @type = 0x06
    @command = 0x07
  end
end


describe RespondableTelegram do
  before do
    @telegram = RespondableTelegram.new
  end

  describe "when using the require_password? property" do
    it "can access the require_response? property" do
      @telegram.require_response?
    end

    it "defaults require_response? to true" do
      @telegram.require_response?.must_equal true
    end

    it "can change require_response? default through initializer" do
      t = RespondableTelegram.new false
      t.require_response?.must_equal false
    end

    it "can set the require_response directly" do
      @telegram.require_response = false
      @telegram.require_response?.must_equal false
    end
  end

  it "must have a readable command property" do
    @telegram.command
  end

  it "must default command to nil" do
    @telegram.command.must_be_nil
  end

  describe "when using the telegram as a collection of bytes" do
    describe "when wanting a reply from this telegram" do
      it "will leave the type in the first byte field alone" do
        mrt = MockRespondableTelegram.new true
        mrt.as_bytes[0].must_equal 0x06
      end
    end
    describe "when NOT wanting to wait for a reply" do
      it "will mask the type with 0x80 to indicate NOT to wait for a reply" do
        mrt = MockRespondableTelegram.new false
        mrt.as_bytes[0].must_equal 0x86
      end
    end

    it "must have the command as the second byte" do
      mrt = MockRespondableTelegram.new
      mrt.as_bytes[1].must_equal 0x07
    end
  end
end
