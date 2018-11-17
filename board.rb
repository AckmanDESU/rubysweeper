require 'awesome_print'
require_relative './tile'

class Board
  attr_accessor :grid, :over

  # @param difficulty [Integer] 1..10
  def initialize(size, difficulty)
    unless difficulty.between? 1, 10
      throw "Wrong difficulty level"
    end

    @over = false
    @difficulty = difficulty
    @grid = Array.new(size) {Array.new}

    fill_board(size)
  end

  def []((row, col))
    return @grid[row] if @grid[row].nil?
    @grid[row][col]
  end

  def []=((row, col), value)
    return if @grid[row].nil?
    @grid[row][col] = value
  end

  def over?
    @over
  end

  def render
    # system "clear" or system "cls"

    puts "   " + (0...@grid.size).to_a.join("  ")
    @grid.each_with_index do |row, idx|
      puts "#{idx} #{row.join("")}"
    end
  end

  def reveal(pos)
    tile = self[pos]
    @over = tile.reveal

    tile
  end

  def fill_board(size)
    ratio = mine_percentage
    mines = 0

    size.times do |row|
      size.times do |col|
        mine = rand(100) <= ratio
        mines += 1 if mine
        @grid[row] << Tile.new(self, [row, col], mine)
      end
    end

    @grid.each {|row| row.each {|tile| tile.get_neighbors}}

    p "Mines: #{mines}"
  end

  def mine_percentage
    (5 + 5.0 * @difficulty)
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new(10, 3)
  b.render
end
