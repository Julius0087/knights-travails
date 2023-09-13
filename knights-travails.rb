class Board
  attr_reader :grid
  def initialize
    @grid = Hash.new
    for i in 0...8
      @grid[i] = Array.new(8) { |x| Node.new([i, x]) } 
    end
  end

  def pretty_print
    @grid.each do |k, v|
      v.each { |x| print "#{x.coordinates.join} " }
      puts ''
    end
  end

  def calculate_moves(node)
    # take the coordinates of this node
    coor_arr = node.coordinates
    y, x = coor_arr[0], coor_arr[1]

    inc_arr_x = [1, 2, 2, 1, -1, -2, -2, -1]
    inc_arr_y = [-2, -1, 1, 2, 2, 1, -1, -2]

    # try all the 8 possible "dots around this node"
    # fill the relationship array with nodes that are possible
    rel_arr = []
    for i in 0...8
      next if @grid[y + inc_arr_y[i]].nil? || (x + inc_arr_x[i] < 0 || x + inc_arr_x[i] > 8)
      
      if @grid[y + inc_arr_y[i]][x + inc_arr_x[i]]
        rel_arr << @grid[y + inc_arr_y[i]][x + inc_arr_x[i]]
      end
    end
    rel_arr
    # map out the entire board of moves???
  end
    
end

class Node
  attr_reader :coordinates
  def initialize(coordinates)
    @coordinates = coordinates
  end

  def <=>(other)
    data <=> other.coordinates
  end
end

gameboard = Board.new
gameboard.pretty_print
p gameboard.calculate_moves(gameboard.grid[3][3])
