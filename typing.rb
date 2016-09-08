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
  start.prog_out
  puts "Please enter the following string"
  question = ('a'..'z').to_a.shuffle[0,10].join
  puts question
  answer = gets.chomp
  if answer == question
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
