require 'win32/sound'
require 'terminal-table'
require 'weather-api'
require 'timeout'
require 'io/console'
include Win32

class Alarm
  def initialize(day_i, day_s, time, on_off, sound, deact)
    @day_i = day_i
    @day_s = day_s
    @time = time
    @on_off = on_off
    @sound = sound
    @deact = deact
  end
  attr_accessor :day_i, :day_s, :time, :on_off, :sound, :deact
  def self.all
    ObjectSpace.each_object(self).to_a
  end
  def alarm_s
    if @sound == 1
      Sound.play('alien.wav')
    elsif @sound == 2
      Sound.play('fire.wav')
    elsif @sound == 3
      Sound.play('siren.wav')
    else
    end
  end
  def alarm_f
    Sound.play('void.wav')
  end
end

# class ToDo
#   def initialize(finish, create)
#     @finish = finish
#     @create = create
#   end
#   attr_accessor :today, :general, :scheduled
# end
#
# class AlarmOff
#   def initialize(simple, maths, typing)
#     @simple = simple
#     @maths = maths
#     @typing = typing
#   end
#   attr_accessor :simple, :maths, :typing
# end

require_relative 'profiles'

menu_a = []
menu_a << ["1 - Add/edit alarms"]
menu_a << ["2 - Add/edit to-dos"]
menu_a << ["3 - See weather"]

menu_t = Terminal::Table.new :title => "#{Time.new.hour}:#{Time.new.min}\n#{Time.new.strftime("%d / %m / %y")}", :rows => menu_a

response = Weather.lookup(1105779, Weather::Units::CELSIUS)

todo = File.open("todo.txt", 'a+').to_a

todo_rows = []

todo.each_with_index do |x, i|
  todo_rows << [i+1, x]
end

todo_t = Terminal::Table.new :title => "My Todo List", :rows => todo_rows

loop do

system "clear" or system "cls"

al_rows = []

write_array = []

Alarm.all.each_with_index do |a, i|
write_array << "$a#{i} = Alarm.new(#{a.day_i}, \"#{a.day_s.to_s}\", \"#{a.time}\", #{a.on_off}, #{a.sound}, #{a.deact})"
  end

File.open("profiles.rb", "w+") do |f|
  f.puts(write_array)
  end

puts menu_t
 Alarm.all.each_with_index do |x, i|
   al_rows << [x.day_i, x.day_s, x.time, x.on_off, x.sound, x.deact]
  end

  if al_rows[0][0] == 6
    al_rows = al_rows.reverse
  else
  end

 alarm_t = Terminal::Table.new :title => "My Alarms", :headings => ["ID #", "Day", "Time", "Active?", "Tone", "Method"], :rows => al_rows

@input1 = nil

  begin
   Timeout::timeout 5 do
     @input1 = gets.chomp.to_i
    end
  rescue Timeout::Error
  end

if @input1 == 1

  puts alarm_t

  puts "1 - Turn alarm on/off\n2 - Edit alarm\n3 - Return to menu"

  input2 = gets.chomp.to_i

  if input2 == 1

    puts "Please enter the alarm's ID\#"

    a_toggle = gets.chomp.to_i

    Alarm.all.each do |x|
      if x.day_i == a_toggle
        x.on_off = !x.on_off
      else
      end
    end
  elsif input2 == 2

    puts "Please enter the alarm ID"

    input3_1 = gets.chomp.to_i

    puts "Please enter the setting to change.\n1 - Time\n2 - Tone\n3 - Method"

    input3_2 = gets.chomp.to_i

    if input3_2 == 1

      puts "Please enter a new time in the format HHMM"

      input_time = gets.chomp.to_s

      Alarm.all.each do |x|
        if x.day_i == input3_1
          x.time = input_time
        else
        end
      end
    elsif input3_2 == 2
      puts "Which tone would you prefer?\n1 - Alien\n2 - Fire alarm\n3 - Siren"

      input_tone = gets.chomp.to_i

      Alarm.all.each do |x|
        if x.day_i == input3_1
          x.sound = input_tone
        else
        end
      end
    elsif input3_2 == 3
      puts "How would you like to turn off the alarm?\n1 - Maths\n2 - Typing\n3 - Any key"

      input_method = gets.chomp.to_i

      Alarm.all.each do |x|
        if x.day_i == input3_1
          x.deact = input_method
        else
        end
      end

    end


  elsif input2 == 3
  end

elsif @input1 == 2

  todo = File.open("todo.txt", 'a+').to_a

  todo_rows = []

  todo.each_with_index do |x, i|
    todo_rows << [i+1, x]
  end

  todo_t = Terminal::Table.new :title => "My Todo List", :rows => todo_rows

  puts todo_t

  puts "1 - Delete entry\n2 - Add entry"

  input_td = gets.chomp.to_i

  if input_td == 1
    puts "Delete which entry?"
    input_td2 = gets.chomp.to_i
    todo.delete_at(input_td2-1)
    File.open("todo.txt", "w+") do |f|
      f.puts(todo)
    end
  elsif input_td == 2
    puts "What would you like to do?"
    todo_new = gets.chomp.to_s
    todo.push(todo_new)
    File.open("todo.txt", "w+") do |f|
      f.puts(todo)
    end
  end

elsif @input1 == 3

  response = Weather.lookup(1105779, Weather::Units::CELSIUS)

  print "#{response.title}
  #{response.condition.temp} degrees
  #{response.condition.text}"

  puts "\nPress any key to return to menu"
  STDIN.getch

else
end

  Alarm.all.each do |y|
    if [Time.new.wday, "#{Time.new.hour}#{Time.new.min}"] == [y.day_i, y.time.to_s]
      if y.deact == 1 && y.on_off == true
        system "clear" or system "cls"
        y.alarm_s
        load 'maths.rb'
        y.alarm_f
        puts "Good morning!"
        puts todo_t
        puts "#{response.title}
        #{response.condition.temp} degrees
        #{response.condition.text}"
        sleep(60)
      elsif y.deact == 2 && y.on_off == true
        system "clear" or system "cls"
        y.alarm_s
        load 'typing.rb'
        puts "Good morning!"
        puts todo_t
        y.alarm_f
        puts "#{response.title}
        #{response.condition.temp} degrees
        #{response.condition.text}"
        sleep(60)
      elsif y.deact == 3 && y.on_off == true
        system "clear" or system "cls"
        y.alarm_s
        puts "Press any key to deactivate alarm"
        STDIN.getch
        y.alarm_f
        puts "Good morning!"
        puts todo_t
        puts "#{response.title}
        #{response.condition.temp} degrees
        #{response.condition.text}"
        sleep(60)
      else
      end
    else
    end
  end
end
