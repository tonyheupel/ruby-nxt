require_relative '../lib/nxt'

nxt = NXT.new('/dev/tty.NXT-DevB')
puts "Connecting..."
begin
  nxt.connect

  C = 523
  G = 392
  A = 440

  E = 659
  D = 587

  WHOLE = 1000
  HALF = WHOLE / 2
  QUARTER = WHOLE / 4

  def dotted(length)
    (length * 1.5).to_i
  end

  Note = Struct.new(:pitch, :length)
  song = [ Note.new(C, QUARTER),
           Note.new(C, QUARTER),
           Note.new(C, QUARTER),
           Note.new(G, QUARTER),

           Note.new(A, QUARTER),
           Note.new(A, QUARTER),
           Note.new(G, HALF),

           Note.new(E, QUARTER),
           Note.new(E, QUARTER),
           Note.new(D, QUARTER),
           Note.new(D, QUARTER),

           Note.new(C, dotted(HALF))
  ]

  puts "Playing song...do you recognize it?"
  song.each do |note|
    nxt.play_tone(note.pitch, note.length)
    sleep(note.length/1000 + 0.3)
  end

  puts "It was Old MacDonald Had a Farm!"
ensure
  nxt.disconnect
end
