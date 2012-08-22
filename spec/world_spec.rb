require_relative '../world'

describe World do
  let(:width) { 10 }
  let(:height) { 10 }
  let(:world) { World.new(height, width) }

  context "when first created" do
    it {world.width.should == width}
    it {world.height.should == height}
    it {world.rows.should have(height).items}
    it "should have all the rows, columns and cells" do
      world.rows.each do |row|
        row.each do |cell|
          cell.should be_kind_of Cell
          world.rows[cell.y][cell.x].should == cell
        end
        row.should have(width).items
      end 
      world.cells.should have(height*width).items
    end

    it "should compute west correctly" do
      world.west(0).should == width-1
      world.west(5).should == 4
    end
    it "should copute east correctly" do
      world.east(width-1).should == 0
      world.east(5).should == 6
    end
    it "should compute north correctly" do
      world.north(0).should == height-1
      world.north(5).should == 4
    end
    it "should compute south correctly" do
      world.south(height-1).should == 0
      world.south(5).should == 6
    end

    it "should set neightbor cells correctly" do
      cell = world.rows[0][0]
      [[width-1,height-1], [0,height-1], [1,height-1], 
       [width-1,0],                      [1,0], 
       [width-1,1],        [0,1],        [1,1]
      ].map{|pair| world.rows[pair[1]][pair[0]]}.
        each{|neighbor| cell.neighbors.should include neighbor}

      cell = world.rows[5][5]
      [[4,4], [4,5], [4,6], 
       [5,4],        [5,6], 
       [6,4], [6,5], [6,6]
      ].map{|pair| world.rows[pair[1]][pair[0]]}.
        each{|neighbor| cell.neighbors.should include neighbor}

      cell = world.rows[height-1][width-1]
      [[width-2,height-2],[width-1,height-2],[0,height-2],
       [width-2,height-1],                   [0,height-1],
       [width-2,0],       [width-1,0],       [0,0]
      ].map{|pair| world.rows[pair[1]][pair[0]]}.
        each{|neighbor| cell.neighbors.should include neighbor}
    end

    it "should determine the future" do
      world.cells.each{|cell| cell.should_receive(:next_future)}
      world.tick!
      world.cells.each{|cell| cell.value.should == cell.future}
    end

    it "should display correctly" do
      world.rows[0][0].value = LiveCell
      world.rows[0][9].value = LiveCell
      world.rows[9][0].value = LiveCell
      world.rows[9][9].value = LiveCell
      (world.to_s+"\n").should == <<-DISPLAY
o........o
..........
..........
..........
..........
..........
..........
..........
..........
o........o
      DISPLAY
    end
  end
end
