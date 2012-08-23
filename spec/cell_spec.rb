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

  context "when answering #change_value_and_notify_neighbors" do
    let(:value){ double "value" }
    let(:change){ double "change" }
    let(:neighbors){ 8.times.map{|n| double "neighbor #{n}"} }


    it "should change value correctly" do
      cell.change_value_and_notify_neighbors value, change
      cell.value.should == value
    end  

    it "should update neighbors correctly" do
      neighbors.each{|n| n.should_receive(:neighboring_change).with change}
      cell.neighbors = neighbors
      cell.change_value_and_notify_neighbors value, change
    end
  end

  context "when answering #neighboring_change" do

    it "should update live_neighbors properly" do
      ->{cell.neighboring_change(-13)}.should change{cell.live_neighbors}.by -13 

    end

    it "should notify the world that a neighbor was changed" do
      cell.world.should_receive(:had_updated_neighbor).with(cell)
      cell.neighboring_change(-13)
    end
  end

end


