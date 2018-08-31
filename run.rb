require_relative 'lib/world'

grid = Struct.new(:width, :height, :live_cells)
random_live_cells = [].tap do |cells|
  0.upto(9) do |y|
    0.upto(9) do |x|
      cells << [x,y] if [false, false, true].sample
    end
  end
end

patterns = {
  blinker: grid.new(5, 5, [[2,1], [2,2], [2,3]]),
  block: grid.new(4, 4, [[1,1], [1,2], [2,1], [2,2]]),
  glider: grid.new(20, 20, [[3,18], [4,17], [4,16], [3,16],[2,16]]),
  random: grid.new(10, 10, random_live_cells),
}

pattern = ARGV.find_index('--pattern') ? ARGV.fetch(ARGV.find_index('--pattern') + 1).to_sym : :random
world = World.new(patterns.fetch(pattern))
steps = ARGV.find_index('--steps') ? ARGV.fetch(ARGV.find_index('--steps') + 1).to_i : 10

steps.times do |step|
  system 'clear'
  puts "Gen #{ step }"
  world.print_board
  world.next_generation
  sleep 1
end
