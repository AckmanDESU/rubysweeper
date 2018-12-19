require 'colorize'
require_relative './board'

class Tile
  attr_reader :pos, :hidden, :mine, :flagged

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
      [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
      [x - 1, y], [x + 1, y],
      [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]
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
    @neighbors.count(&:mine)
  end

  def flag_count
    @neighbors.count(&:flagged)
  end

  def reveal(force = false)
    if force
      @hidden = false
      return
    end

    return false if @flagged

    @hidden = false

    if !@mine && buddy_count == 0 ||
       !@hidden && buddy_count == flag_count
      @neighbors.select(&:hidden?).each(&:reveal)
    end

    @board.trigger_all if @mine

    @mine
  end

  def flag
    return false unless @hidden

    @flagged = !@flagged
  end

  def inspect
    "Pos: #{pos} - Value: #{self}"
  end

  alias hidden? hidden

  def buddy_color
    case buddy_count
    when 1 then :blue
    when 2 then :green
    when 3 then :red
    when 4 then :purple
    else; :white
    end
  end

  def to_s
    if @flagged
      '[F]'.yellow
    elsif hidden?
      '[_]'.colorize(color: :black, background: :white)
    elsif mine
      '[*]'.red
    elsif buddy_count > 0
      "[#{buddy_count}]".colorize(buddy_color)
    else
      '   '
    end
  end
end
