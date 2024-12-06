def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day06_testinput.txt')
REAL_INPUT = import_from_file('day06_input.txt')

NORTH = [-1, 0]
EAST = [0, 1]
SOUTH = [1, 0]
WEST = [0, -1]
DIRECTIONS = {
  '^' => NORTH,
  '>' => EAST,
  'v' => SOUTH,
  '<' => WEST
}

def obstacle?(grid, y, x)
  return false unless in_area?(grid, [y, x])
  grid[y][x] == '#'
end

def find_guard(grid)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      if DIRECTIONS.key?(grid[y][x])
        return [[y, x], DIRECTIONS[grid[y][x]]]
      end
    end
  end
end

def in_area?(grid, location)
  location[0] >= 0 && location[0] < grid.length && location[1] >= 0 && location[1] < grid.first.length
end

def part_one(input)
  visited = Set.new
  grid = input.split("\n").map!(&:chomp)
  location, direction = find_guard(grid)
  while in_area?(grid, location)
    visited << location
    if obstacle?(grid, location[0] + direction[0], location[1] + direction[1])
      direction = case direction
                  when NORTH then EAST
                  when EAST then SOUTH
                  when SOUTH then WEST
                  when WEST then NORTH
                  end
    else
      location[0] += direction[0]
      location[1] += direction[1]
    end
  end
  visited.size - 1
end

def part_two(input)
  count = 0
  grid = input.split("\n").map!(&:chomp)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      unless obstacle?(grid, y, x) || DIRECTIONS.key?(grid[y][x])
        new_grid = grid.dup
        (0...new_grid.size).each { |n| new_grid[n] = grid[n].dup }
        new_grid[y][x] = '#'
        location, direction = find_guard(new_grid)
        visited = Set.new
        loop_detection = 0
        while in_area?(new_grid, location)
          if visited.include?(location)
            loop_detection += 1
          else
            visited << location
            loop_detection = 0
          end
          if loop_detection >= [visited.size, grid.size].max
            count += 1
            break
          end
          if obstacle?(new_grid, location[0] + direction[0], location[1] + direction[1])
            direction = case direction
                        when NORTH then EAST
                        when EAST then SOUTH
                        when SOUTH then WEST
                        when WEST then NORTH
                        end
          else
            location[0] += direction[0]
            location[1] += direction[1]
          end
        end
      end
    end
  end
  count
end

p part_one(TEST_INPUT) # should be 41
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 6
p part_two(REAL_INPUT)