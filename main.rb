#!/usr/bin/env ruby
require_relative 'life'
require_relative 'toroid'

class DisplayThrottler

  attr_accessor :framerate

  def initialize framerate
    @framerate = framerate
    @last_throttle_time = Time.now
    @ticks_left_until_odd_throttle = 13 
  end
 
  def throttle
    sleep_and_return [time_left_for_this_frame, odd_throttle_delay].max
  end


private

  def time_left_for_this_frame
    time_allotted_per_frame - time_since_last_frame
  end

  def time_allotted_per_frame
    @time_allotted_per_frame ||= compute_time_allotted_per_frame 
  end

  def time_since_last_frame
    time = Time.now - @last_throttle_time
    @last_throttle_time = Time.now
    time
  end


  def compute_time_allotted_per_frame
    if framerate <= 0
      0.0
    else
      1.0/framerate
    end
  end

  def sleep_and_return delay 
    sleep delay
    delay
  end

  def odd_throttle_delay
    @ticks_left_until_odd_throttle -= 1
    if @ticks_left_until_odd_throttle <= 0 
      @ticks_left_until_odd_throttle = 13 
      0.01
    else
      0
    end
  end 
 
end


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

def main
  clear_screen
  display_throttler =  DisplayThrottler.new (ARGV[0] || 10).to_i
  world = initialize_world 
  ticks = time_for_ticks = 0
  while true do
    start = Time.now
    display(world)
    printf "%10ith iterations\n", ticks+=1
    printf "%10.04g ticks per second\n", ticks / (time_for_ticks + 0.000001)
    time_for_ticks += time_for_tick(world)
    printf "throttling %10.04g seconds\n", display_throttler.throttle 
  end
end

main
