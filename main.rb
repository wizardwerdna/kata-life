#!/usr/bin/env ruby
require          'benchmark'
require_relative 'life'
require_relative 'toroid'
require_relative 'lib/life_file_reader'
require_relative 'lib/display_throttler'
require_relative 'lib/world_display'

class MainLine

  attr_accessor :screen_height, :screen_width, :framerate                     # options
  attr_accessor :world, :world_display, :display_throttler, :life_file_reader # collaborators
  attr_accessor :number_of_generations, :time_computing_generations           # statistics

  def initialize options
    self.screen_height = (options[:screen_height] || 100).to_i
    self.screen_width  = (options[:screen_width]  || 100).to_i
    self.framerate     = (options[:framerate]     ||  10).to_i

    configure_collaborators
  end
  
  def run 
    initialize_for_next_run
    while true do
      compute_next_generation
      world_display.display_updated_cells
      display_footer
    end
  end

private

  def configure_collaborators
    self.world = ToroidalWorld.new(screen_height-lines_for_footer, screen_width)
    self.world_display = WorldDisplay.new world 
    self.display_throttler = DisplayThrottler.new framerate 
    self.life_file_reader = LifeFileReader.new(world)
  end

  def initialize_for_next_run
    self.number_of_generations = 0
    self.time_computing_generations = 0
    
    load_model_and_pause
    world_display.clear_and_display_all_cells
  end

  def compute_next_generation
    self.time_computing_generations += Benchmark.realtime do
      world.tick!
    end
    self.number_of_generations += 1
  end

  def load_model_and_pause
    life_file_reader.load_stdin
    sleep 2
  end

  def lines_for_footer
    4
  end

  def display_footer
    world_display.at(0, world.height).display    "%10d generations", number_of_generations
    world_display.at(0, world.height+1).display  "%10.04g generations per second", 
      1.0 * number_of_generations / time_computing_generations  
    world_display.at(0, world.height+2).display  "throttling %10.04g seconds", display_throttler.throttle
  end

end

MainLine.new( screen_height: `tput lines`, screen_width: `tput cols`, framerate: ARGV[0] ).run
