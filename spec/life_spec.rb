require_relative '../life'

describe LiveCell do
  let(:death_future_strategy){ double "death_future_strategy" }
  let(:null_future_strategy){ double "null_future_strategy" }
  before :each do
    DeathFutureStrategy.stub(:new => death_future_strategy)
    NullFutureStrategy.stub(:new => null_future_strategy)
  end

  it "should diplay as 'o'" do
    LiveCell.to_s.should == 'o'
  end

  it "Rule 1: live cell with fewer than two neighbors dies" do
    for neighbors in 0..1
      cell = stub :live_neighbors => neighbors
      LiveCell.future(cell).should == death_future_strategy 
    end
  end

  it "Rule 2: live cell with two or three neighbors survives" do
    for neighbors in 2..3
      cell = stub :live_neighbors => neighbors
      LiveCell.future(cell).should == null_future_strategy 
    end
  end

  it "Rule 3: live cell with more than three neighbors dies" do
    for neighbors in 4..8 
      cell = stub :live_neighbors => neighbors
      LiveCell.future(cell).should == death_future_strategy 
    end
  end

end

describe DeadCell do
  let(:birth_future_strategy){ double "birth_future_strategy" }
  let(:null_future_strategy){ double "null_future_strategy" }
  before :each do
    BirthFutureStrategy.stub(:new => birth_future_strategy)
    NullFutureStrategy.stub(:new => null_future_strategy)
  end

  it "should display as '.'" do
    DeadCell.to_s.should == '.'
  end

  it "Rule 4: dead cell with exactly three neighbors becomes live" do
    cell = stub :live_neighbors => 3
    DeadCell.future(cell).should == birth_future_strategy 
  end

  it "Rule 4a(implied): cell with other than three neighbors stays dead" do
    for neighbor in [0, 1, 2,   4, 5, 6, 7, 8] 
      cell = stub :live_neighbors => neighbor
      DeadCell.future(cell).should == null_future_strategy
    end
  end

end
