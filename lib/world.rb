require_relative 'cell'

class World
  attr_reader :board, :grid

  def initialize(grid)
    location = Struct.new(:x, :y)
    @grid = grid
    @board = [].tap do |cells|
      0.upto(grid.width - 1) do |x|
        0.upto(grid.height - 1) do |y|
          cells << Cell.new(location.new(x, y), self, grid.live_cells.include?([x,y]))
        end
      end
    end
  end

  def next_generation
    marked_cells.each(&:toggle!)
  end

  def cell_at(x_coord, y_coord)
    return nil if coords_out_of_range?(x_coord, y_coord)
    board.detect do |cell|
      cell.x_coord == x_coord && cell.y_coord == y_coord
    end
  end

  def print_board
    0.upto(grid.height - 1) do |y|
      0.upto(grid.width - 1) do |x|
        cell = cell_at(x, y)
        printf (cell.alive? ? 'X' : 'O')
      end
      puts "\n"
    end
  end

  private

  def marked_cells
    board.map(&:should_be_toggled?).compact
  end

  def coords_out_of_range?(x_coord, y_coord)
    (x_coord < 0 || x_coord >= grid.width) || (y_coord < 0 || y_coord >= grid.height)
  end
end
