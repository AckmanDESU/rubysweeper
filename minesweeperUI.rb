require_relative './board'
require_relative './minesweeper'
require_relative './save'

require 'colorize'
require 'remedy'
require 'yaml'

class MineUI < Minesweeper
  include Remedy

  def save
    File.write('save.yaml', to_yaml)
  end

  def self.load
    YAML.load(File.read('save.yaml'))
  end

  def initialize(*args)
    super

    @selected = [0, 0]
  end

  def render
    system('clear') || system('cls')

    grid = @board.grid.map.with_index do |r, y|
      r.map.with_index do |c, x|
        if @selected == [y, x]
          c.to_s.colorize(color: :white, background: :blue)
        else
          c
        end
      end
    end

    puts "Mines: #{@board.mines}"

    puts '   ' + '---' * grid.size
    grid.each_with_index do |row, _idx|
      puts " | #{row.join('')} |"
    end
    puts '   ' + '---' * grid.size
  end

  def move_to(pos)
    y, x = @selected
    new_pos = [@selected, pos].transpose.map(&:sum)
    new_pos

    @selected = new_pos if valid_pos?(new_pos)
  end

  def process_input(key)
    options = {
      left: -> { move_to([0, -1]) },
      right: -> { move_to([0, 1]) },
      up: -> { move_to([-1, 0]) },
      down: -> { move_to([1, 0]) },
      r: -> { @board.reveal(@selected) },
      f: -> { @board.flag(@selected) }
    }

    options[key] || -> { p 'no' }
  end

  def play
    render

    user_input = Interaction.new
    user_input.loop do |key|
      process_input(key.name).call
      render
      p key.name
      p @selected

      break if game_over?
    end
  end
end

if $PROGRAM_NAME == __FILE__
  game = MineUI.new(10, 3)
  game.save

  game2 = MineUI.load
  game2.play
end
