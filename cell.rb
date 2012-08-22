class Cell

  attr_accessor :x, :y, :world, :value, :neighbors, :live_neighbors, :future

  def initialize x, y, world
    self.x = x
    self.y = y
    self.world = world
    self.value = DeadCell
    self.neighbors = []
    self.live_neighbors = 0
  end

  def next_future
    self.future = value.future(self)
  end

  def neighboring_birth
    self.live_neighbors += 1
    world.had_updated_neighbor(self)
  end

  def neighboring_death
    self.live_neighbors -= 1
    world.had_updated_neighbor(self)
  end

  def update
    if future_birth?
      neighbors.each{|n| n.neighboring_birth}
    elsif future_death?
      neighbors.each{|n| n.neighboring_death}
    end
    self.value = future
  end

private

  def future_birth?
    value == DeadCell && future == LiveCell
  end

  def future_death?
    value == LiveCell && future == DeadCell
  end

end
