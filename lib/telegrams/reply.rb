require_relative './telegram'

class Reply < Telegram
  COMMAND_TYPE = 0x02
  SUCCESS = 0x00
  STATUS_MESSAGES = {
    SUCCESS => 'Success',
    # base error messages
    0x81 => 'No more handles',
    0x82 => 'No space',
    0x83 => 'No more files',
    0x84 => 'End of file expected',
    0x85 => 'End of file',
    0x86 => 'Not a linear file',
    0x87 => 'File not found',
    0x88 => 'Handle all ready closed',
    0x89 => 'No linear space',
    0x8A => 'Undefined error',
    0x8B => 'File is busy',
    0x8C => 'No write buffers',
    0x8D => 'Append not possible',
    0x8E => 'File is full',
    0x8F => 'File exists',
    0x90 => 'Module not found',
    0x91 => 'Out of boundary',
    0x92 => 'Illegal file name',
    0x93 => 'Illegal handle',

    # command replies
    0x20 => 'Pending communication transaction in progress',
    0x40 => 'Specified mailbox queue is empty',
    0xBD => 'Request failed (i.e., specified file not found)',
    0xBE => 'Unknown command opcode',
    0xBF => 'Insane packet',
    0xC0 => 'Data contains out-of-range values',
    0xDD => 'Communication bus error',
    0xDE => 'No free memory in communication buffer',
    0xDF => 'Specified channel/connection is not valid',
    0xE0 => 'Specified channel/connection not configured or busy',
    0xEC => 'No active program',
    0xED => 'Illegal size specified',
    0xEE => 'Illegal mailbox queue ID specified',
    0xEF => 'Attempted to access invalid field of a structure',
    0xF0 => 'Bad input or output specified',
    0xFB => 'Insufficient memory available',
    0xFF => 'Bad arguments'
  }

  attr_accessor :type, :command, :status, :message_bytes

  def initialize(bytes=nil)
    validate_bytes(bytes)
    @type = bytes[0]
    @command = bytes[1]
    @status = bytes[2]
    @message_bytes = bytes[3..-1]
    @status_description = nil
  end


  def success?
    status == SUCCESS
  end

  def status_description
    if @status_description.nil?
      @status_description = STATUS_MESSAGES.include?(status) ? STATUS_MESSAGES[status] : ''
    end

    @status_description
  end

  def message
    # override in subclasses to translate bytes to something meaningful
    message_bytes
  end


  private
  def validate_bytes(bytes)
    raise ArgumentError, "must be non-nil" if bytes.nil?
    raise ArgumentError, "must have a type, command, and status" unless bytes.size && bytes.size >= 3
    raise ArgumentError, "must be a reply telegram" unless bytes[0] == COMMAND_TYPE
  end
end
