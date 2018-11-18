require_relative './board'
require_relative './minesweeper'

require 'colorize'
require 'remedy'

class MineUI < Minesweeper
  include Remedy

  def initialize(*args)
    super(*args)

    @selected = [0,0]
  end

  def render
    system "clear" or system "cls"

    grid = @board.grid.map.with_index do |r,y|
      r.map.with_index do |c, x|
        if @selected == [y, x]
          c.to_s.colorize(:color => :white, :background => :blue)
        else
          c
        end
      end
    end

    puts "Mines: #{@board.mines}"

    puts "     " + (0...grid.size).to_a.join("  ")
    puts "    " + "---" * grid.size
    grid.each_with_index do |row, idx|
      puts "#{idx} | #{row.join("")}"
    end
  end

  def move_to(pos)
    y, x = @selected
    new_pos = [@selected, pos].transpose.map(&:sum)
    new_pos

    @selected = new_pos if valid_pos?(new_pos)
  end

  def process_input(key)
    options = {
      :left => ->{ move_to([0,-1]) },
      :right => ->{ move_to([0,1]) },
      :up => ->{ move_to([-1,0]) },
      :down => ->{ move_to([1,0]) },
      :control_m => -> { @board.reveal(@selected) },
      :f => -> { @board.flag(@selected) }
    }

    options[key] || ->{p "no"}
  end

  def play
    render

    user_input = Interaction.new
    user_input.loop do |key|
      process_input(key.name).call()
      render
      p key.name
      p @selected

      break if game_over?
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  game = MineUI.new(10, 3)
  game.play
end
