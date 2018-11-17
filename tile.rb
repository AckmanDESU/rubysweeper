require_relative './board'

class Tile
  attr_reader :pos, :value, :hidden, :mine

  def initialize(board, pos, mine)
    @board = board
    @pos = pos
    @mine = mine
    @hidden = true
  end

  # @return [Array<Tile>]
  def get_neighbors
    neighbors = []
    x, y = @pos

    surroundings = [[x-1, y-1], [x, y-1], [x+1, y-1], [x-1, y], [x+1, y], [x-1, y+1], [x, y+1], [x+1, y+1]]
    surroundings
      .select {|pos| pos.all? {|num| num >= 0}}
      .each do |pos|
      neighbor = @board[pos]
      neighbors << neighbor unless neighbor.nil?
    end

    @neighbors = neighbors
  end

  def buddy_count
    @neighbors.count {|tile| tile.mine}
  end

  def reveal
    @hidden = false

    if !@mine && buddy_count == 0
      @neighbors.each {|n| n.reveal}
    end

    @mine
  end

  def inspect
    "Pos: #{pos} - Value: #{self.to_s}"
  end

  alias_method :hidden?, :hidden

  def to_s
    if hidden?
      "[#]"
    elsif mine
      "[*]"
    elsif buddy_count > 0
      "[#{buddy_count}]"
    else
      "[ ]"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
end
