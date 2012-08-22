require_relative '../world'

describe World do

  let(:width) { 10 }
  let(:height) { 10 }
  let(:world) { World.new(height, width) }
  let(:cell) {Cell.new(0,0,world)}

  it {world.width.should == width}
  it {world.height.should == height}
  it {world.cells_with_updated_neighbors.should have(0).items}

  it "should handle cell_updates notices correctly" do
    ->{world.had_updated_neighbor cell}.should change{world.cells_with_updated_neighbors.count}.by(1)
    ->{world.had_updated_neighbor cell}.should change{world.cells_with_updated_neighbors.count}.by(0)
    world.cells_with_updated_neighbors.should include cell
  end

  it "should determine the future for cells with updated neighbors" do
    world.cells_with_updated_neighbors = Set.new [cell] 
    cell.should_receive(:next_future)
    world.tick!
    cell.value.should == cell.future
  end

end
