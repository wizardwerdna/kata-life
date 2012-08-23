require_relative '../future_strategy'

describe FutureStrategy do

  let(:cell){ double "cell" }
  let(:future_strategy){ FutureStrategy.new(cell) }
  subject{ future_strategy }

  context "upon creation" do

    it{ subject.cell.should == cell }
  
  end

end

describe NullFutureStrategy do

  it "should run" do
    NullFutureStrategy.new(stub).run
  end

end


describe BirthFutureStrategy do
  let(:cell) { double "cell" } 
  subject { BirthFutureStrategy.new(cell) }

  it "should update correctly" do
    cell.should_receive(:change_value_and_notify_neighbors).with(LiveCell, 1)
    subject.run
  end

end

describe DeathFutureStrategy do
  let(:cell) { double "cell" } 
  subject { DeathFutureStrategy.new(cell) }

  it "should update correctly" do
    cell.should_receive(:change_value_and_notify_neighbors).with(DeadCell, -1)
    subject.run
  end

end
