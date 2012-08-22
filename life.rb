require_relative 'world'

class DeadCell 

  def self.to_s; "."; end
  
  def self.future cell 
    if cell.live_neighbors == 3
      LiveCell 
    else
      DeadCell
    end
  end

end

class LiveCell

  def self.to_s; "o"; end

  def self.future cell 
    if cell.live_neighbors.between?(2,3)
      LiveCell
    else
      DeadCell
    end
  end

end


