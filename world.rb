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

  def marked_cells
    board.map(&:should_be_toggled?).compact
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

  def coords_out_of_range?(x_coord, y_coord)
    (x_coord < 0 || x_coord >= grid.width) || (y_coord < 0 || y_coord >= grid.height)
  end
end

class Cell
  attr_reader :location, :world, :alive

  def initialize(location, world, alive)
    @location = location
    @world = world
    @alive = alive
  end

  def dead?
    !alive?
  end

  def alive?
    !!alive
  end

  def should_be_toggled?
    return self if alive? && should_be_swept?
    return self if dead? && should_be_resurrected?
    nil
  end

  def should_be_resurrected?
    live_neighbor_count == 3
  end

  def x_coord
    location.x
  end

  def y_coord
    location.y
  end

  def should_be_swept?
    ![2, 3].include?(live_neighbor_count)
  end

  def toggle!
    @alive = !alive
  end

  def neighbors
    x_coords = (location.x - 1..location.x + 1).to_a
    y_coords = (location.y - 1..location.y + 1).to_a
    neighbors = x_coords.product(y_coords) - [[location.x, location.y]]
    neighbors.map {|n| world.cell_at(n[0], n[1])}
  end

  def live_neighbor_count
    neighbors.compact.count(&:alive?)
  end
end

grid = Struct.new(:width, :height, :live_cells)
blinker = grid.new(5, 5, [[2,1], [2,2], [2,3]])
block = grid.new(4, 4, [[1,1], [1,2], [2,1], [2,2]])
glider = grid.new(20, 20, [[3,18], [4,17], [4,16], [3,16],[2,16]])

world = World.new(glider)

20.times do |step|
  system 'clear'
  puts "Gen #{ step }"
  world.print_board
  world.next_generation
  sleep 1
end
