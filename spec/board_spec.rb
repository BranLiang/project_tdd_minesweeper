require 'spec_helper'

describe Mineswiper do

  let(:new_board){ Mineswiper::Board.new }

  context '#initialize' do
    it 'has a grid array' do
      expect(new_board.grid).to be_a(Array)
    end

    it 'return false for win or lose' do
      expect(new_board.lost).to be false
      expect(new_board.won).to be false
    end
  end

  context '#prepared_board' do
    it 'calls populate_mines' do
      expect(new_board).to receive(:populate_mines)
      expect(new_board).to receive(:assign_bomb_counts)
      new_board.prepared_board
    end
  end

  context '#populate_mines' do
    it 'fill all elements in grid with a tile' do
      new_board.populate_mines
      result = new_board.grid.all? do |row|
        row.all? do |tile|
          tile.is_a? Mineswiper::Tile
        end
      end
      expect(result).to be true
    end

    it 'should have both bomb and no bomb tiles' do
      new_board.populate_mines
      bomb_counter = 0
      new_board.grid.each do |row|
        row.each do |tile|
          bomb_counter += 1 if tile.bomb == true
        end
      end
      expect(bomb_counter).to be_within(24*24/20).of(24*24/10)
    end
  end

  context '#get_indices' do
    it 'return an array including all tiles' do
      new_board.get_indices
      expect(new_board.all_indices.length).to eq(24*24)
    end
    it 'all children is an array with length row and col only' do
      new_board.get_indices
      result = new_board.all_indices.all? do |child|
        (child.is_a? Array) && child.length == 2
      end
    end
  end

  context '#find_neighbers' do
    it 'has 8 neighbours for position 1, 1' do
      neighbors = new_board.find_neighbers([1, 1])
      expect(neighbors.length).to eq(8)
    end
    it 'has 3 neighbours for position 0, 0' do
      neighbours = new_board.find_neighbers([0, 0])
      expect(neighbours.length).to eq(3)
    end
    it 'has 5 neighbors for position 0, 1' do
      neighbors = new_board.find_neighbers([0, 1])
      expect(neighbors.length).to eq(5)
    end
  end

  context '#count_adjacent_bombs' do
    it 'some tile has adj_bombs more than 0' do
      new_board.populate_mines
      (0..23).each do |row|
        (0..23).each do |col|
          new_board.count_adjacent_bombs([row, col])
        end
      end
      counter = 0
      new_board.grid.each do |row|
        row.each do |el|
          counter += 1 if el.adj_bombs > 0
        end
      end
      expect(counter).to be > 0
      expect(counter).to be < 24*24
    end
  end

  context '#flag_pos' do
    it 'flag the position' do
      new_board.populate_mines
      new_board.flag_pos([1, 1])
      result = new_board.grid[1][1].flag
      expect(result).to be true
    end

    it 'upflag the position already flaged' do
      new_board.populate_mines
      new_board.flag_pos([1, 1])
      expect(new_board.grid[1][1].flag).to be true
      new_board.flag_pos([1, 1])
      expect(new_board.grid[1][1].flag).to be false
    end
  end

  context '#won?' do
    it 'should return false when for the initialized board' do
      new_board.populate_mines
      new_board.get_indices
      expect(new_board.won?).to be false
    end
  end

end
