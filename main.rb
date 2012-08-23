#!/usr/bin/env ruby
require_relative 'life'
require_relative 'toroid'
require_relative 'life_file_reader'
require_relative 'display_throttler'
require_relative 'world_display'

class MainLine

  attr_accessor :world, :world_display, :display_throttler,
    :number_of_generations, :time_computing_generations

  def initialize
    self.world = ToroidalWorld.new(`tput lines`.to_i-4, `tput cols`.to_i)
    self.world_display = WorldDisplay.new world 
    self.display_throttler = DisplayThrottler.new (ARGV[0] || 10).to_i


    self.number_of_generations = 0
    self.time_computing_generations = 0
  end
  
  def run 
    prepare_for_run
    while true do
      compute_next_generation
      world_display.display_updated_cells
      display_footer
    end
  end

private

  def prepare_for_run
    LifeFileReader.new(world).load_stdin
    sleep 2
    world_display.clear_and_display_all_cells
  end

  def compute_next_generation
    start = Time.now
    world.tick!
    self.number_of_generations += 1
    self.time_computing_generations += Time.now - start
  end

  def display_footer
    world_display.at(0, world.height).display    "%10d generations", number_of_generations
    world_display.at(0, world.height+1).display  "%10.04g generations per second", 
      1.0 * number_of_generations / time_computing_generations  
    world_display.at(0, world.height+2).display  "throttling %10.04g seconds", display_throttler.throttle
  end

end

MainLine.new.run
