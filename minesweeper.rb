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

  def get_player_input
    sleep 1
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

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new(10, 3)
  game.play
end
