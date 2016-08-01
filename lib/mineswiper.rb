require_relative "mineswiper/version"
require_relative "mineswiper/board"
require_relative "mineswiper/tile"
require_relative 'mineswiper/player'
require_relative 'mineswiper/display'
require 'colorize'
require 'io/console'
require 'pry-byebug'

module Mineswiper
  class Game

    attr_accessor :board, :name, :player

    def initialize(name: "Player1", board: Board.new)
      @board = board
      @board.prepared_board
      @player = Player.new(@board)
    end

    def play
      until game_over?
        # binding.pry
        board.parse_input(player.move)
      end

      if board.lost?
        board.all_indices.each do |idx|
          x, y = idx
          board.grid[x][y].hidden = false
        end
        player.display.render
        puts "You lose! BOOOM"
      else
        puts "You win"
      end
    end

    def game_over?
      board.won? || board.lost?
    end



  end
end
