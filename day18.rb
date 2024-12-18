def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day18_testinput.txt')
REAL_INPUT = import_from_file('day18_input.txt')

def build_grid(size, input, num_bytes)
  grid = Array.new(size) { Array.new(size) { { corrupt: false, distance: nil } } }
  input.each_with_index do |corrupt_byte, n|
    x, y = corrupt_byte.split(',').map(&:to_i)
    grid[y][x][:corrupt] = true
    break if n >= num_bytes - 1
  end
  grid
end

def traverse(position, grid, distance, allow_any_path = false)
  here = grid[position[:y]][position[:x]]
  if here[:distance] && distance >= here[:distance]
    return false
  else
    here[:distance] = distance
  end
  return true if position[:x] == grid.size - 1 && position[:y] == grid.size - 1
  if position[:x] < grid.size - 1
    east = grid[position[:y]][position[:x] + 1]
    found = traverse({ x: position[:x] + 1, y: position[:y] }, grid, distance + 1, allow_any_path) unless east[:corrupt]
    return true if allow_any_path && found
  end
  if position[:y] < grid.size - 1
    south = grid[position[:y] + 1][position[:x]]
    found = traverse({ x: position[:x], y: position[:y] + 1 }, grid, distance + 1, allow_any_path) unless south[:corrupt]
    return true if allow_any_path && found
  end
  if position[:x] > 0
    west = grid[position[:y]][position[:x] - 1]
    found = traverse({ x: position[:x] - 1, y: position[:y] }, grid, distance + 1, allow_any_path) unless west[:corrupt]
    return true if allow_any_path && found
  end
  if position[:y] > 0
    north = grid[position[:y] - 1][position[:x]]
    found = traverse({ x: position[:x], y: position[:y] - 1 }, grid, distance + 1, allow_any_path) unless north[:corrupt]
    return true if allow_any_path && found
  end
  false
end

def part_one(size, input, num_bytes)
  parsed_input = input.split("\n")
  grid = build_grid(size, parsed_input, num_bytes)
  position = { x: 0, y: 0 }
  traverse(position, grid, 0)
  grid.last.last[:distance]
end

def part_two(size, input, num_bytes)
  parsed_input = input.split("\n")
  grid = build_grid(size, parsed_input, num_bytes)
  position = { x: 0, y: 0 }
  i = num_bytes
  while traverse(position, grid, 0, true)
    # reset the grid
    grid.each {|row| row.each {|cell| cell[:distance] = nil}}
    i += 1
    x, y = parsed_input[i].split(',').map(&:to_i)
    grid[y][x][:corrupt] = true
  end
  grid.each {|row| p row.map {|cell| cell[:distance]}}
  parsed_input[i]
end

p part_one(7, TEST_INPUT, 12) # should be 22
p part_one(71, REAL_INPUT, 1024)

p part_two(7, TEST_INPUT, 12) # should be 6,1
p part_two(71, REAL_INPUT, 1024)