class World
  attr_reader :board, :dimension

  def initialize(seed_grid)
    @dimension = seed_grid.grid_size
    @board = Array.new(@dimension) do |x|
      Array.new(@dimension) do |y|
        Cell.new(x, y, self, grid_size.live_cells.include?([x,y]))
      end
    end
  end

  def next_generation
    marked_cells = []
    board.flatten.each do |cell|
      if cell.alive?
        if ![2, 3].include?(cell.live_neighbor_count)
          marked_cells << cell
        end
      else
        if cell.live_neighbor_count == 3
          marked_cells << cell
        end
      end
    end
    marked_cells.each(&:toggle!)
  end

  def cell_at(x_coord, y_coord)
    return nil if coords_out_of_range?(x_coord, y_coord)
    board[x_coord][y_coord]
  end

  def print_board
    board.transpose.each do |row|
      row.each do |cell|
        printf (cell.alive? ? 'X' : 'O')
      end
      puts "\n"
    end
  end

  private

  def coords_out_of_range?(x_coord, y_coord)
    (x_coord < 0 || x_coord >= dimension) || (y_coord < 0 || y_coord >= dimension)
  end
end


class Cell
  attr_reader :x, :y, :world, :alive

  def initialize(x, y, world, alive)
    @x = x
    @y = y
    @world = world
    @alive = alive
  end

  def alive?
    !!alive
  end

  def toggle!
    @alive = !alive
  end

  def neighbors
    [
        world.cell_at(x - 1, y + 1), world.cell_at(x - 1, y - 1), world.cell_at(x - 1, y),
        world.cell_at(x, y + 1), world.cell_at(x, y - 1),
        world.cell_at(x + 1, y + 1), world.cell_at(x + 1, y - 1), world.cell_at(x + 1, y)
    ]
  end

  def live_neighbor_count
    neighbors.compact.count(&:alive?)
  end
end

grid = Struct.new(:grid_size, :live_cells)
blinker = grid.new(5, [[2,1], [2,2], [2,3]])
block = grid.new(4, [[1,1], [1,2], [2,1], [2,2]])

world = World.new(blinker)

10.times do |step|
  system 'clear'
  puts "Gen #{ step }"
  world.print_board
  world.next_generation
  sleep 1
end