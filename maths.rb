require 'date'

class Progress
  def initialize(progress, total)
    @progress = progress
    @total = total
  end
  def increment
    if @progress < total
      @progress = @progress + 1
    else
    end
  end
  def progress
    @progress
  end
  def total
    @total
  end
  def prog_out
    puts "[#{@progress}/#{total}]"
  end
end

start = Progress.new(0, 3)

until start.progress == start.total do
  system "clear" or system "cls"
  prng1 = Random.new
  num1 = prng1.rand(100)
  num2 = prng1.rand(100)
  num3 = prng1.rand(100)
  start.prog_out
  puts "#{num1} + #{num2} + #{num3} = ?"
  answer = gets.chomp.to_i

  if answer == (num1 + num2 + num3)
    puts "Correct!"
    start.increment
    sleep(1)
  else
    puts "Try again"
    sleep(1)
  end
end
system "clear" or system "cls"
start.prog_out
puts "YOU DID IT"
