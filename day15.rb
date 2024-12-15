def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day15_testinput1.txt')
TEST_INPUT_2 = import_from_file('day15_testinput2.txt')
REAL_INPUT = import_from_file('day15_input.txt')

def find_robot(grid)
  (0...grid.length).each do |y|
    (0...grid[y].length).each do |x|
      return [y, x] if grid[y][x] == '@'
    end
  end
end

def find_boxes(grid)
  boxes = Set.new
  (0...grid.length).each do |y|
    (0...grid[y].length).each do |x|
      if %w(O [).include?(grid[y][x])
        boxes << [y, x]
      end
    end
  end
  boxes
end

def move(object, direction, grid)
  to_check = case direction
             when '>'
               [object[0], object[1] + 1]
             when 'v'
               [object[0] + 1, object[1]]
             when '<'
               [object[0], object[1] - 1]
             when '^'
               [object[0] - 1, object[1]]
             end
  case grid[to_check[0]][to_check[1]]
  when '#' # found wall, can't move
    [0, 0]
  when 'O' # found box, trying to move
    result = move(to_check, direction, grid)
    unless result == [0, 0]
      grid[to_check[0]][to_check[1]] = grid[object[0]][object[1]]
      grid[object[0]][object[1]] = '.'
    end
    result
  else # found clear space, moving
    grid[to_check[0]][to_check[1]] = grid[object[0]][object[1]]
    grid[object[0]][object[1]] = '.'
    case direction
    when '>'
      [0, 1]
    when 'v'
      [1, 0]
    when '<'
      [0, -1]
    when '^'
      [-1, 0]
    end
  end
end

def move2(object, direction, grid, dry_run: false)
  to_check = case direction
             when '>'
               [object[0], object[1] + 1]
             when 'v'
               [object[0] + 1, object[1]]
             when '<'
               [object[0], object[1] - 1]
             when '^'
               [object[0] - 1, object[1]]
             end
  case grid[to_check[0]][to_check[1]]
  when '#' # found wall, can't move
    [0, 0]
  when '[', ']' # found box-half, trying to move
    result = if %w[v ^].include?(direction)
               check1 = grid[to_check[0]][to_check[1]] == '[' ? to_check : [to_check[0], to_check[1] - 1]
               check2 = grid[to_check[0]][to_check[1]] == ']' ? to_check : [to_check[0], to_check[1] + 1]
               result1 = move2(check1, direction, grid, dry_run: dry_run)
               result2 = move2(check2, direction, grid, dry_run: dry_run)
               result1 == result2 ? result1 : [0, 0]
             else
               move2(to_check, direction, grid, dry_run: dry_run)
             end
    unless result == [0, 0] || dry_run
      grid[to_check[0]][to_check[1]] = grid[object[0]][object[1]]
      grid[object[0]][object[1]] = '.'
    end
    result
  else # found clear space, moving
    unless dry_run
      grid[to_check[0]][to_check[1]] = grid[object[0]][object[1]]
      grid[object[0]][object[1]] = '.'
    end
    case direction
    when '>'
      [0, 1]
    when 'v'
      [1, 0]
    when '<'
      [0, -1]
    when '^'
      [-1, 0]
    end
  end
end

def part_one(input)
  grid, instructions = input.split("\n\n")
  grid = grid.split("\n")
  instructions = instructions.split("\n").join
  robot = find_robot(grid)
  (0...instructions.length).each do |i|
    inst = instructions[i]
    dy, dx = move(robot, inst, grid)
    robot[0] += dy
    robot[1] += dx
  end
  boxes = find_boxes(grid)
  boxes.map { |box| box[0] * 100 + box[1] }.sum
end

def scale_up!(grid)
  grid.each do |row|
    row.gsub!('#', '##')
    row.gsub!('O', '[]')
    row.gsub!('.', '..')
    row.gsub!('@', '@.')
  end
  grid
end

def part_two(input)
  small_grid, instructions = input.split("\n\n")
  grid = scale_up!(small_grid.split("\n"))
  instructions = instructions.split("\n").join
  robot = find_robot(grid)
  (0...instructions.length).each do |i|
    inst = instructions[i]
    unless move2(robot, inst, grid, dry_run: true) == [0, 0]
      dy, dx = move2(robot, inst, grid)
      robot[0] += dy
      robot[1] += dx
    end
  end
  boxes = find_boxes(grid)
  boxes.map { |box| box[0] * 100 + box[1] }.sum
end

p part_one(TEST_INPUT) # should be 2028
p part_one(TEST_INPUT_2) # should be 10092
p part_one(REAL_INPUT)

p part_two(TEST_INPUT_2) # should be 9021
p part_two(REAL_INPUT)