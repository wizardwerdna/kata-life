class World

  attr_accessor :height, :width, :rows
  def initialize height, width
    self.height = height
    self.width = width
    instantiate_cells
    position_cells
  end

  def instantiate_cells
    self.rows = Array.new(height) do |y|
      cols = Array.new(width) do |x|
        Cell.new(x,y,self)  
      end
      cols        
    end
  end

  def position_cells
    cells.each do |cell|
      rows[north cell.y][west cell.x].neighbors << cell
      rows[north cell.y][     cell.x].neighbors << cell
      rows[north cell.y][east cell.x].neighbors << cell
      rows[      cell.y][west cell.x].neighbors << cell
      rows[      cell.y][east cell.x].neighbors << cell
      rows[south cell.y][east cell.x].neighbors << cell
      rows[south cell.y][     cell.x].neighbors << cell
      rows[south cell.y][west cell.x].neighbors << cell
    end
  end

  def cells
    Enumerator.new do |enum|
      rows.each{|r| r.each{|c| enum << c}}
    end
  end

  def tick!
    cells.each do |cell| 
      cell.next_future
    end
    cells.each{|cell| cell.update}
  end

  def north(y); y==0 ? height - 1 : y  - 1; end
  def south(y); y==height-1 ? 0 : y + 1; end
  def east(x); x==width-1 ? 0 : x + 1; end
  def west(x); x==0 ? width-1 : x - 1; end

  def to_s
    rows.map do |row|
      row.map{|cell| cell.value.to_s}.join
    end.join("\n")
  end
end
