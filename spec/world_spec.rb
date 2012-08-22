require_relative '../world'
describe World do

  let(:width) { 10 }
  let(:height) { 10 }
  let(:world) { World.new(height, width) }
  let(:cell) {Cell.new(0,0,world)}

  context "upon initialization" do

    it {world.width.should == width}
    it {world.height.should == height}
    it {world.cells_with_updated_neighbors.should have(0).items}

  end

  context "on #had_updated_neighbor" do

    it "should add cell to updated_neighbors list on first call" do
      ->{world.had_updated_neighbor cell}.
        should change{world.cells_with_updated_neighbors.count}.by(1)
      world.cells_with_updated_neighbors.should include cell
    end

    it "should not add a changed cell on subsequent calls" do 
      world.had_updated_neighbor cell
      ->{world.had_updated_neighbor cell}.
        should change{world.cells_with_updated_neighbors.count}.by(0)
      world.cells_with_updated_neighbors.should include cell
    end

  end

  context "every tick!" do

    before :each do
      cell.value = stub(:future => nil)
      cell.future = stub
      world.cells_with_updated_neighbors = Set.new [cell] 
    end

    it "cells with updated neighbors should be asked to compute their future" do
      cell.should_receive(:next_future)
      world.tick!
    end
 
    it "cells with updated neighbors should be asked to update theselves" do
      cell.should_receive(:update)
      world.tick!
    end

  end

end
