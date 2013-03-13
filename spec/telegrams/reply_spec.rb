require 'minitest/autorun'

require_relative '../../lib/telegrams/reply'

describe Reply do
  before do
    @reply = Reply.new
  end

  describe "the telegram type for a reply" do
    it "must be 0x02" do
      @reply.type.must_equal 0x02
    end
  end

  describe "as bytes" do
    it "must have the type as the first element of the array" do
      @reply.as_bytes[0].must_equal @reply.type
    end
  end
end
