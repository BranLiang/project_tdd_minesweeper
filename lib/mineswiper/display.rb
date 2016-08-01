module Mineswiper
  class Display

    COLORS = {
      0 => :light_black,
      1 => :green,
      2 => :cyan,
      3 => :light_blue,
      4 => :blue,
      5 => :light_magenta,
      6 => :magenta,
      7 => :light_black,
      8 => :black
    }

    GLOBAL_BACKGROUND = :light_white


    attr_accessor :board

    def initialize(board)
      @board = board
      @cursor_pos = [0, 0]
    end

    def build_grid
      @board.grid.each_index do |i|
        rowdisplay = ""
        @board.grid[i].each_index do |j|
          output = board.grid[i][j].tilerender
          color_options = colors_for(i, j)
          rowdisplay << output.colorize(color_options) + " ".colorize(background: GLOBAL_BACKGROUND) unless output.nil?
        end
        puts rowdisplay
      end
    end

    def colors_for(i, j)
      if [i, j] == @cursor_pos
        bg = :light_red
      else
        bg = GLOBAL_BACKGROUND
      end

      if (@board.grid[i][j].hidden == false)
        color = COLORS[@board.grid[i][j].adj_bombs]
        if @board.grid[i][j].bomb?
          color = :light_red
        end
      elsif @board.grid[i][j].flagged?
        color = :light_red
      else
        color = :white
      end
      { background: bg, color: color }
    end

    def render
      system("clear")
      puts "W-A-S-D to move the cursor - Spacebar to reveal."
      build_grid
    end

    KEYMAP = {
      " " => :space,
      "f" => :f,
      "a" => :left,
      "s" => :down,
      "w" => :up,
      "d" => :right,
      "\u0003" => :ctrl_c,
    }

    MOVES = {
      left: [0, -1],
      right: [0, 1],
      up: [-1, 0],
      down: [1, 0]
    }

    def get_input
      key = KEYMAP[read_char]
      handle_key(key)
    end

    def handle_key(key)
      case key
      when :ctrl_c
        exit 0
      when :space
        @cursor_pos
      when :left, :right, :up, :down
        update_pos(MOVES[key])
        nil
      when :f
        [:flag, @cursor_pos]
      else
        puts key
      end
    end

    def read_char
      STDIN.echo = false
      STDIN.raw!

      input = STDIN.getc.chr
      if input == "\e" then
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.echo = true
      STDIN.cooked!

      return input
    end

    def update_pos(diff)
      new_pos = [@cursor_pos[0] + diff[0], @cursor_pos[1] + diff[1]]
      @cursor_pos = new_pos if @board.in_bounds?(new_pos)
    end

  end
end
