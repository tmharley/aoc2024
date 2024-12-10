def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day10_testinput.txt')
REAL_INPUT = import_from_file('day10_input.txt')

SCORE = 1
RATING = 2

def process(input, mode)
  total = 0
  grid = []
  input = input.split("\n").map!(&:chomp)
  input.each do |row|
    grid << row.split('').map!(&:to_i)
  end
  (0...grid.size).each do |x|
    (0...grid[x].size).each do |y|
      if grid[x][y] == 0
        result = climb(grid, x, y, mode)
        total += (mode == RATING ? result : result.size)
      end
    end
  end
  total
end

def climb(grid, location_x, location_y, mode)
  elevation = grid[location_x][location_y]
  return (mode == RATING ? 1 : Set.new([[location_x, location_y]])) if elevation == 9
  peaks = (mode == RATING ? 0 : Set.new)
  if location_x > 0 && grid[location_x - 1][location_y] == elevation + 1
    peaks += climb(grid, location_x - 1, location_y, mode)
  end
  if location_x < grid.size - 1 && grid[location_x + 1][location_y] == elevation + 1
    peaks += climb(grid, location_x + 1, location_y, mode)
  end
  if location_y > 0 && grid[location_x][location_y - 1] == elevation + 1
    peaks += climb(grid, location_x, location_y - 1, mode)
  end
  if location_y < grid.first.size - 1 && grid[location_x][location_y + 1] == elevation + 1
    peaks += climb(grid, location_x, location_y + 1, mode)
  end
  peaks
end

def part_one(input)
  process(input, SCORE)
end

def part_two(input)
  process(input, RATING)
end

p part_one(TEST_INPUT) # should be 36
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 81
p part_two(REAL_INPUT)