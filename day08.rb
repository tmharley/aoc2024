def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day08_testinput.txt')
REAL_INPUT = import_from_file('day08_input.txt')

def find_antennas(grid)
  antennas = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).zip(Array.new(62) { [] }).to_h
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      antennas[grid[y][x]] << [y, x] if antennas.key?(grid[y][x])
    end
  end
  antennas.delete_if { |k, v| v.empty? }
end

def part_one_antinode?(y, x, antennas)
  antennas.each do |freq, locations|
    locations.each do |location|
      dy = location[0] - y
      dx = location[1] - x
      if locations.any? { |l| (l[0] != y || l[1] != x) && (l[0] - y == 2 * dy && l[1] - x == 2 * dx) }
        return true
      end
    end
  end
  false
end

def part_two_antinode?(y, x, antennas)
  antennas.each do |freq, locations|
    locations.each do |location|
      if location[1] == x
        return true if locations.count { |l| l[1] == x } > 1
      else
        diff = Rational(location[0] - y, location[1] - x)
        if locations.count { |l| (l[0] == y && l[1] == x) || (l[1] != x && Rational(l[0] - y, l[1] - x) == diff) } > 1
          return true
        end
      end
    end
  end
  false
end

def part_one(input)
  total = 0
  grid = input.split("\n").map!(&:chomp)
  antennas = find_antennas(grid)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      total += 1 if part_one_antinode?(y, x, antennas)
    end
  end
  total
end

def part_two(input)
  total = 0
  grid = input.split("\n").map!(&:chomp)
  antennas = find_antennas(grid)
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      total += 1 if part_two_antinode?(y, x, antennas)
    end
  end
  total
end

p part_one(TEST_INPUT) # should be 14
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 34
p part_two(REAL_INPUT)