require './spec/helper'

require './lib/telegrams/reply'

describe Reply do
  before do
    @reply = Reply.new([0x02, 0x11, 0x00])
  end
  describe "when constructing a reply" do
    it "must have a command type of 0x02, which is reply" do
      @reply.type.must_equal 0x02
    end

    it "must raise an ArgumentError if the bytes is null" do
      -> { Reply.new(nil) }.must_raise ArgumentError
    end

    it "must raise an ArgumentError if the bytes is less than 3 length (type, command, status)" do
      -> { Reply.new([0x02, 0x00]) }.must_raise ArgumentError
    end

    it "must raise an ArgumentError if it is not a reply telegram" do
      -> { Reply.new([0x01, 0x01, 0x00]) }.must_raise ArgumentError
    end

  end

  describe "#success?" do
    it "must return true when status is 0x00" do
      @reply.success?.must_equal true
    end

    it "must return false when the status is not 0x00" do
      Reply.new([0x02, 0x11, 0x01]).success?.must_equal false
    end
  end

  describe "#message_bytes" do
    it "must have an empty array when there is no message" do
      @reply.message_bytes.must_equal []
    end

    it "must have the 4th through remaining message bytes when there is a message" do
      Reply.new([0x02, 0x11, 0x00, 0x01, 0x02]).message_bytes.must_equal [0x01, 0x02]
    end
  end

  describe "#message" do
    it "must just return the bytes of the message in the base Reply class" do
      Reply.new([0x02, 0x11, 0x00, 0x01, 0x02]).message.must_equal [0x01, 0x02]
    end
  end

  describe "#status_description" do
    it "must return empty string if there is no matching code" do
      Reply.new([0x02, 0x11, 0xfa]).status_description.must_equal ''
    end

    it "must return the string for the status when there is a matching code" do
      Reply.new([0x02, 0x11, 0x00]).status_description.must_equal 'Success'
    end
  end
end
