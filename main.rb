#!/usr/bin/env ruby
require_relative 'life'
require_relative 'toroid'

def time_for_tick(world)
  start = Time.now
  world.tick!
  Time.now - start
end

def set_cell cell, value
  return if cell.value == value
  if value == DeadCell
    DeathFutureStrategy.new(cell).run
  else
    BirthFutureStrategy.new(cell).run
  end
end

def initialize_world
  world = ToroidalWorld.new(`tput lines`.to_i-4, `tput cols`.to_i)
  world.cells.each do |cell|
    set_cell cell, [DeadCell, LiveCell].sample
 end
 world
end

def clear_screen
  `tput reset; tput clear`
end

def display(world)
  puts "\033[H" + world.to_s + "\n"
end

def sleep_and_return delay 
  sleep delay
  delay
end

def odd_throttle_delay
  @ticks_for_odd_throttle ||= 1 
  @ticks_for_odd_throttle -= 1
  if @ticks_for_odd_throttle <= 0
    @ticks_for_odd_throttle = 13 
    sleep_and_return 0.01
  else
    0
  end
end 

def throttle(framerate)
  if framerate <= 0
    sleep_and_return 0 
  else
    @start ||= Time.now
    time_left_for_frame = (1.0/framerate) - (Time.now-@start)
    @start = Time.now
    delay = [time_left_for_frame, odd_throttle_delay].max
    sleep_and_return delay
  end
end

def main
  clear_screen
  framerate = (ARGV[0] || 10).to_i
  world = initialize_world 
  ticks = time_for_ticks = 0
  time_per_frame = 1.0 / framerate
  while true do
    start = Time.now
    display(world)
    printf "%10ith iterations\n", ticks+=1
    printf "%10.04g ticks per second\n", ticks / (time_for_ticks + 0.000001)
    time_for_ticks += time_for_tick(world)
    printf "throttling %10.04g seconds\n", throttle(framerate) 
  end
end

main
