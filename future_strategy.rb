class FutureStrategy

  attr_accessor :cell
  def initialize cell
    self.cell = cell
  end

  def run
  end

end

class NullFutureStrategy < FutureStrategy; end

class BirthFutureStrategy < FutureStrategy

  def run
    cell.change_value_and_notify_neighbors(LiveCell, 1)
  end

end

class DeathFutureStrategy < FutureStrategy

  def run
    cell.change_value_and_notify_neighbors(DeadCell, -1)
  end

end

