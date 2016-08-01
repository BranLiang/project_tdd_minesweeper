require 'spec_helper'

describe Mineswiper do

  let(:cell){ Mineswiper::Tile.new([1, 1]) }

  context '#initialize' do
    it 'is not a bomb' do
      expect(cell.bomb).to be false
    end

    it 'is hidden' do
      expect(cell.hidden).to be true
    end

    it 'has no flag' do
      expect(cell.flag).to be false
    end

    it 'has no adjcent bombs' do
      expect(cell.adj_bombs).to eq(0)
    end
  end

  context '#tilerender' do
    it 'return flag when it is flaged' do
      cell.flag_it
      expect(cell.tilerender).to eq("\u2691".encode('utf-8'))
    end

    it 'return square tile when hidden' do
      expect(cell.tilerender).to eq("\u25A0".encode('utf-8'))
    end

    it 'return circle when it is bomb' do
      cell.reveal
      # allow(cell).to receive(hidden).and_return(false)
      allow(cell).to receive(:bomb?).and_return(true)
      expect(cell.tilerender).to eq("\n2688".encode('utf-8'))
    end
  end

end
