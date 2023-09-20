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

  def calculate_moves(node, node_hash)
    # take the coordinates of this node
    coor_arr = node.coordinates
    y, x = coor_arr[0], coor_arr[1]

    inc_arr_x = [1, 2, 2, 1, -1, -2, -2, -1]
    inc_arr_y = [-2, -1, 1, 2, 2, 1, -1, -2]

    # try all the 8 possible positions around this node
    # fill the relationship array with nodes that are possible
    rel_arr = []
    for i in 0...8
      next if @grid[y + inc_arr_y[i]].nil? || (x + inc_arr_x[i] < 0 || x + inc_arr_x[i] > 8)

      current_node = @grid[y + inc_arr_y[i]][x + inc_arr_x[i]]
      if current_node && !node_hash.to_a.flatten.include?(current_node)
        rel_arr << current_node
        current_node.parent = node
      end
    end
    rel_arr
  end

  def knight_moves(start_position, end_position, num_of_moves = 1)
    # invalid coordinated handling
    if !start_position[0].between?(0, 8) || !start_position[1].between?(0, 8)
      puts 'Invalid coordinates for starting position'
      return
    elsif !end_position[0].between?(0, 8) || !end_position[1].between?(0, 8)
      puts 'Invalid coordinates for end position'
      return
    end

    # find a node that corresponds to the start and end position
    start_node = @grid[start_position[0]][start_position[1]]
    end_node = @grid[end_position[0]][end_position[1]]

    node_hash = {
      0 => [start_node],
      1 => [],
      2 => [],
      3 => [],
      4 => [],
      5 => [],
      6 => []
    }
    return 0 if start_position == end_position

    # calculate moves for that node
    node_hash[num_of_moves] << calculate_moves(start_node, node_hash)
    node_hash[num_of_moves].flatten!
    # p node_hash[num_of_moves]

    while num_of_moves <= 6 do
      if node_hash[num_of_moves].include?(end_node)
        break
      else
        node_hash[num_of_moves].each do |node|
          # p node_hash
          node_hash[num_of_moves + 1] << calculate_moves(node, node_hash)
        end
        node_hash[num_of_moves + 1].flatten!.uniq!
        # exclude duplicates from previous number and root
        node_hash[num_of_moves + 1] = node_hash[num_of_moves + 1] - node_hash[num_of_moves]
        node_hash[num_of_moves + 1].delete(start_node)
      end
      num_of_moves += 1
    end
    puts "The knight moved in #{num_of_moves} move(s)! Here's the path:"
    path = find_path(end_node)
    path.each { |x| p x }
  end

  def find_path(node)
    arr = []
    until node.parent.nil?
      arr.unshift(node.coordinates)
      node = node.parent
    end
    arr.unshift(node.coordinates)
  end
end

class Node
  attr_reader :coordinates
  attr_accessor :parent

  def initialize(coordinates)
    @coordinates = coordinates
    @parent = nil
  end
end

gameboard = Board.new
# gameboard.pretty_print
# p gameboard.calculate_moves(gameboard.grid[3][3])
gameboard.knight_moves([7, 0], [0, 6])
