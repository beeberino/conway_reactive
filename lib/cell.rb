require_relative 'world'

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

  def x_coord
    location.x
  end

  def y_coord
    location.y
  end

  def toggle!
    @alive = !alive
  end

  private

  def should_be_swept?
    ![2, 3].include?(live_neighbor_count)
  end

  def should_be_resurrected?
    live_neighbor_count == 3
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
