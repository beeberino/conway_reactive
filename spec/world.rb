require_relative('../lib/world')
require_relative('../lib/cell')

describe World do
  let(:grid) do
    Struct.new(:width, :height, :live_cells)
  end
  let(:blinker) {grid.new(5, 5, [[2,1], [2,2], [2,3]])}
  let(:block) {grid.new(4, 4, [[1,1], [1,2], [2,1], [2,2]])}

  def get_live_cells(world)
    world.board.select(&:alive?).map do |cell|
      [cell.x_coord, cell.y_coord]
    end
  end

  describe 'fixed' do
    it 'the next generation is the same as the current' do
      world = World.new(block)
      original_live_cells = get_live_cells(world)
      world.next_generation
      new_live_cells = get_live_cells(world)
      expect(new_live_cells).to eq original_live_cells
    end
  end

  describe 'oscillator' do
    it 'the next generation swaps x and y coordinates' do
      world = World.new(blinker)
      original_live_cells = get_live_cells(world)
      world.next_generation
      second_gen_live_cells = get_live_cells(world)
      expect(second_gen_live_cells.map(&:reverse)).to eq original_live_cells
      world.next_generation
      third_gen_live_cells = get_live_cells(world)
      expect(third_gen_live_cells).to eq original_live_cells
    end
  end
end
