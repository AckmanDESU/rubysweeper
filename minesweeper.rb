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
      pos.map! {|el| Integer(el)}
    rescue
      return false
    end

    !@board[pos].nil?
  end

  def valid_mode?(mode)
    ["r", "f", ""].include?(mode.downcase)
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
      print "> "
      input = parse_input(gets.chomp)
    end

    input
  end

  def play
    until game_over?
      @board.render

      *pos, mode = get_player_input
      pos.map!(&:to_i)

      puts "mode:  #{mode}"
      puts "pos:  #{pos}"

      if mode == "r"
        @board.reveal(pos)
      else # mode == "f"
        @board.reveal(pos)
        # @board.flag(pos)
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new(10, 3)
  game.play
end
