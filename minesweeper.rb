require 'awesome_print'
require_relative './tile'
require_relative './board'

class Minesweeper
  def initialize(size, difficulty)
    @board = Board.new(size, difficulty)
  end

  def game_over?
    false
  end

  def get_player_input
    ["r", [0, 0]]
  end

  def play
    until game_over?
      @board.render

      mode, pos = get_player_input

      if mode == "r"
        @board.reveal(pos)
      else # mode == "f"
        @board.reveal(pos)
        # @board.flag(pos)
      end
    end
  end
end
