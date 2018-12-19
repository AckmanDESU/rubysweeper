require 'awesome_print'
require_relative './tile'
require_relative './board'

class Minesweeper
  def initialize(size, difficulty)
    @board = Board.new(size, difficulty)
  end

  def game_over?
    @board.over?
  end

  def valid_pos?(pos)
    begin
      pos.map! { |el| Integer(el) }
    rescue StandardError
      return false
    end

    return false if pos.any? { |n| n < 0 }

    !@board[pos].nil?
  end

  def valid_mode?(mode)
    ['r', 'f', ''].include?(mode.downcase)
  end

  def valid_input?((row, col, mode))
    valid_pos?([row, col]) && valid_mode?(mode)
  end

  def parse_input(input)
    input
      .split(/\s|,/)
      .reject(&:empty?)
  end

  def get_player_input
    input = nil

    until input && valid_input?(input)
      puts "Enter a position like so: row, column - add an 'f' at the end to flag it or 'r' to reveal it"
      print '> '
      input = parse_input(gets.chomp)
    end

    input
  end

  def play
    @board.render

    until game_over?
      *pos, mode = get_player_input
      pos.map!(&:to_i)

      puts "mode:  #{mode}"
      puts "pos:  #{pos}"

      if mode == 'f'
        @board.flag(pos)
      else # mode == "f"
        @board.reveal(pos)
      end

      @board.render
    end
  end
end

if $PROGRAM_NAME == __FILE__
  game = Minesweeper.new(10, 3)
  game.play
end
