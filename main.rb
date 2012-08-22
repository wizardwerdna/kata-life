#!/usr/bin/env ruby
require_relative 'life'
require_relative 'toroid'

def time_for_tick(world)
  start = Time.now
  world.tick!
  Time.now - start
end

def initialize_world
  world = ToroidalWorld.new(`tput lines`.to_i-4, `tput cols`.to_i)
  world.cells.each do |cell|
    cell.future = [LiveCell, DeadCell].shuffle.first
    cell.update
  end
  world
end

def clear_screen
  `tput reset; tput clear`
end

def display(world)
  puts "\033[H" + world.to_s + "\n"
end

def main
  clear_screen
  world = initialize_world 
  ticks = time_for_ticks = 0
  framerate = ARGV[0].to_i || 10 
  time_per_frame = 1.0 / framerate
  while true do
    start = Time.now
    display(world)
    printf "%10ith iterations\n", ticks+=1
    printf "%10.04g ticks per second\n", ticks / (time_for_ticks + 0.000001)
    time_for_ticks += time_for_tick(world)
    printf "throttling %10.04g seconds", [time_per_frame - (Time.now-start), 0].max
    sleep [time_per_frame - (Time.now-start), 0].max
  end
end

main
