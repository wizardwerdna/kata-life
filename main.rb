#!/usr/bin/env ruby
require_relative 'life'
require_relative 'toroid'

def timeForTick(world)
  start = Time.now
  world.tick!
  Time.now - start
end

def initializeWorld
  world = ToroidalWorld.new(60, 250)
  world.cells.each do |cell|
    cell.future = [LiveCell, DeadCell].shuffle.first
    cell.update
  end
  world
end

def clearScreen
  puts "\033[2J"
end

def display(world)
  puts "\033[H" + world.to_s + "\n"
end

def main
  world = initializeWorld 
  ticks = timeForTicks = 0
  while true do
    display(world)
    printf "%10ith iterations\n", ticks+=1
    printf "%10.04g ticks per second\n", ticks / (timeForTicks + 0.000001)
    timeForTicks += timeForTick(world)
  end
end

main
