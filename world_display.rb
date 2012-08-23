class WorldDisplay

  attr_accessor :world
  def initialize world
    self.world = world
    self.clear
  end

  def clear
    display "\e[H\e[2J"
    self
  end

  def at x, y 
    display "\e[%d;%dH", y+1, x+1 
    self
  end

  def display string, *args
    printf string, *args
    self
  end

  def display_updated_cells
    for cell in world.cells_with_updated_neighbors
      self.at(cell.x, cell.y).display cell.value.to_s
    end
    self
  end

  def clear_and_display_all_cells
    self.clear 
    display world.to_s
    self
  end
end
