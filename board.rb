require 'awesome_print'
require_relative './tile'

class Board
  attr_accessor :grid, :over, :mines

  # @param difficulty [Integer] 1..10
  def initialize(size, difficulty)
    throw 'Wrong difficulty level' unless difficulty.between? 1, 10

    @over = false
    @difficulty = difficulty
    @grid = Array.new(size) { [] }

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
    system('clear') || system('cls')

    puts "Mines: #{@mines}"

    puts '     ' + (0...@grid.size).to_a.join('  ')
    puts '    ' + '---' * @grid.size
    @grid.each_with_index do |row, idx|
      puts "#{idx} | #{row.join('')}"
    end
  end

  def reveal(pos)
    tile = self[pos]
    @over = tile.reveal

    tile
  end

  def trigger_all
    @grid.each do |row|
      row.select(&:mine).each { |t| t.reveal(true) }
    end
  end

  def flag(pos)
    self[pos].flag
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

    @grid.each { |row| row.each(&:get_neighbors) }

    @mines = mines
  end

  def mine_percentage
    (5 + 5.0 * @difficulty)
  end
end

if $PROGRAM_NAME == __FILE__
  b = Board.new(10, 3)
  b.render
end
