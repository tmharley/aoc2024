def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
INPUT

DIRECTIONS = [
  [0, -1], # north
  [1, -1], # northeast
  [1, 0], # east
  [1, 1], # southeast
  [0, 1], # south
  [-1, 1], # southwest
  [-1, 0], # west
  [-1, -1] # northwest
]

REAL_INPUT = import_from_file('day04_input.txt')

def part_one(input)
  input = input.split("\n").map!(&:chomp)
  count = 0
  min_x, min_y, max_x, max_y = [0, 0, input.first.length - 1, input.length - 1]
  (0...input.length).each do |y|
    (0...input[y].length).each do |x|
      if input[y][x] == 'X'
        DIRECTIONS.each do |dx, dy|
          next if x + dx * 3 < min_x || y + dy * 3 < min_y || x + dx * 3 > max_x || y + dy * 3 > max_y
          if input[y + dy][x + dx] == 'M' && input[y + dy * 2][x + dx * 2] == 'A' && input[y + dy * 3][x + dx * 3] == 'S'
            count += 1
          end
        end
      end
    end
  end
  count
end

def part_two(input)
  input = input.split("\n").map!(&:chomp)
  count = 0
  (1...(input.length - 1)).each do |y|
    (1...(input[y].length - 1)).each do |x|
      count += 1 if x_mas?(input, y, x)
    end
  end
  count
end

def x_mas?(input, y, x)
  input[y][x] == 'A' &&
    ((input[y - 1][x - 1] == 'M' && input[y + 1][x + 1] == 'S') ||
      (input[y - 1][x - 1] == 'S' && input[y + 1][x + 1] == 'M')) &&
    ((input[y - 1][x + 1] == 'M' && input[y + 1][x - 1] == 'S') ||
      (input[y - 1][x + 1] == 'S' && input[y + 1][x - 1] == 'M'))
end

p part_one(TEST_INPUT) # should be 18
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 9
p part_two(REAL_INPUT)