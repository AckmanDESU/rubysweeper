require_relative './board'

class Tile
  attr_reader :pos, :hidden, :mine

  def initialize(board, pos, mine)
    @board = board
    @pos = pos
    @mine = mine
    @hidden = true
    @flagged = false
  end

  # TODO: Differenciate diagonal neighbors from direct ones when revealing
  # @return [Array<Tile>]
  def get_neighbors
    neighbors = []
    x, y = @pos

    surroundings = [
      [x-1, y-1], [x, y-1], [x+1, y-1],
      [x-1, y], [x+1, y],
      [x-1, y+1], [x, y+1], [x+1, y+1]
    ]

    surroundings
      .select { |pos| pos.all? { |num| num >= 0 } }
      .each do |pos|
      neighbor = @board[pos]
      neighbors << neighbor unless neighbor.nil?
    end

    @neighbors = neighbors
  end

  def buddy_count
    @neighbors.count {|tile| tile.mine}
  end

  def reveal(force=false)
    if force
      @hidden = false
      return
    end

    return false if @flagged

    @hidden = false

    if !@mine && buddy_count == 0
      @neighbors.select(&:hidden?).each {|n| n.reveal}
    end

    if @mine
      @board.trigger_all
    end

    @mine
  end

  def flag
    return false unless @hidden
    @flagged = !@flagged
  end

  def inspect
    "Pos: #{pos} - Value: #{self.to_s}"
  end

  alias_method :hidden?, :hidden

  def to_s
    if @flagged
      "[F]"
    elsif hidden?
      "[_]"
    elsif mine
      "[*]"
    elsif buddy_count > 0
      "[#{buddy_count}]"
    else
      "   "
    end
  end
end
