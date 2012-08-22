require_relative '../cell'

describe Cell do
  let(:world){ double "world", :had_updated_neighbor => nil }
  let(:y){ 8 }
  let(:x){ 5 } 
  let(:cell){ Cell.new(x, y, world) }

  context "when first created" do

    it "should have the correct coordinates and world" do
      cell.x.should == x
      cell.y.should == y
      cell.world.should == world
    end

    it "should have no neighbors" do
      cell.should have(0).neighbors
    end

  end

  context "when computing #next_future" do
    let(:future_value) {double "future value"}
    before :each do
      cell.value = stub(:future => future_value)
    end

    it "should get new value from old value and neighbors" do
      cell.value.should_receive(:future).with(cell).and_return(future_value)
      cell.next_future
    end

    it "should answer the proper new value" do
      cell.next_future.should == future_value
    end

    it "should change cell future correctly" do
      cell.next_future
      cell.future.should == future_value
    end
  end

  it "should be able to recognize a neighboring birth" do
    cell.world.should_receive(:had_updated_neighbor).with(cell)
    ->{cell.neighboring_birth}.should change{cell.live_neighbors}.by(1)
  end

  it "should be able to recognize a neighboring death" do
    cell.world.should_receive(:had_updated_neighbor).with(cell)
    ->{cell.neighboring_death}.should change{cell.live_neighbors}.by(-1)
  end


  context "after futures have been computed" do
 
    let(:present_value){double "present value"}
    let(:future_value){double "future value"}
    let(:neighbor){double "neighbor"} 

    it "should set value to future" do
      cell.value = present_value
      cell.future = future_value
      cell.update.should == future_value
      cell.value.should == future_value 
    end

    it "should update_neighbors after a death" do
      cell.value = LiveCell
      cell.future = DeadCell
      cell.neighbors = [neighbor]
      neighbor.should_receive :neighboring_death
      cell.update
    end

    it "should update_neighbors after a death" do
      cell.value = LiveCell
      cell.future = DeadCell
      cell.neighbors = [neighbor]
      neighbor.should_receive :neighboring_death
      cell.update
    end

  end

end


