module Mineswiper
  class Tile

    attr_accessor :state, :flag, :hidden, :number, :adj_bombs
    attr_reader :pos, :bomb

    def initialize(pos, bomb=false)
      @pos, @bomb = pos, bomb
      @hidden = true
      @flag = false
      @adj_bombs = 0
    end

    def reveal
      @hidden = false
    end

    def bomb?
      @bomb == true
    end

    def flagged?
      @flag
    end

    def flag_it
      @flag = true
    end

    def unflag
      flag = false
    end

    def tilerender
      if flagged?
        return "\u2691".encode('utf-8')
      elsif @hidden
        return "\u25A0".encode('utf-8')
      elsif bomb?
        return "\u2622".encode('utf-8')
      else
        return self.adj_bombs.to_s
      end
    end

  end
end
