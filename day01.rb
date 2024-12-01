def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
INPUT

REAL_INPUT = import_from_file('day01_input.txt')

def parse(lines)
  left = []
  right = []
  lines.each do |line|
    /(\d+)\s*(\d+)/.match(line) do |m|
      left << m[1].to_i
      right << m[2].to_i
    end
  end
  [left, right]
end

def part_one(input)
  lines = input.split("\n").map!(&:chomp)
  left, right = parse(lines)
  left.sort!
  right.sort!
  (0...left.size).each.map do |i|
    (left[i] - right[i]).abs
  end.sum
end

def part_two(input)
  lines = input.split("\n").map!(&:chomp)
  left, right = parse(lines)
  left.each.map do |n|
    n * right.count(n)
  end.sum
end

p part_one(TEST_INPUT) # should be 11
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 31
p part_two(REAL_INPUT)