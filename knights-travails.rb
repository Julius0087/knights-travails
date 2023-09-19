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
  end

  def knight_moves(start_position, end_position, num_of_moves = 1)
    # find a node that corresponds to the start and end position
    start_node = @grid[start_position[0]][start_position[1]]
    end_node = @grid[end_position[0]][end_position[1]]

    node_hash = {
      1 => [],
      2 => [],
      3 => [],
      4 => [],
      5 => [],
      6 => []
    }
    return 0 if start_position == end_position

    # calculate moves for that node
    node_hash[num_of_moves] << calculate_moves(start_node)
    node_hash[num_of_moves].flatten!
    # p node_hash[num_of_moves]

    while num_of_moves <= 6 do
      if node_hash[num_of_moves].include?(end_node)
        return num_of_moves
      else
        node_hash[num_of_moves].each do |node|
          # p node_hash
          node_hash[num_of_moves + 1] << calculate_moves(node)
        end
        node_hash[num_of_moves + 1].flatten!.uniq!
        # exclude duplicates from previous number and root
        node_hash[num_of_moves + 1] = node_hash[num_of_moves + 1] - node_hash[num_of_moves]
        node_hash[num_of_moves + 1].delete(start_node)
      end
      num_of_moves += 1
    end
    puts "The knight moved in #{num_of_moves} move(s)! Here's the path:"
    # TODO:
    # the path
  end
    
end

class Node
  attr_reader :coordinates
  def initialize(coordinates)
    @coordinates = coordinates
  end

  # def <=>(other)
  #   data <=> other.coordinates
  # end
end

gameboard = Board.new
gameboard.pretty_print
# p gameboard.calculate_moves(gameboard.grid[3][3])
p gameboard.knight_moves([3, 3], [0, 0])
