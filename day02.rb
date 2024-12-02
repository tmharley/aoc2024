def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = <<~INPUT
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
INPUT

REAL_INPUT = import_from_file('day02_input.txt')

def evaluate(reports)
  return false unless (reports[1] - reports[0]).abs.between?(1, 3)
  if reports[1] > reports[0] # increasing
    (2...reports.size).each do |n|
      return false unless (reports[n] - reports[n - 1]).between?(1, 3)
    end
  else # decreasing
    (2...reports.size).each do |n|
      return false unless (reports[n - 1] - reports[n]).between?(1, 3)
    end
  end
  true
end

def evaluate2(reports)
  if evaluate(reports)
    true
  else
    (0...reports.size).each do |n|
      (r2 = reports.dup).delete_at(n)
      return true if evaluate(r2)
    end
    false
  end
end

def part_one(input)
  lines = input.split("\n").map!(&:chomp)
  lines.each.map do |line|
    reports = line.split.map(&:to_i)
    evaluate(reports)
  end.count(true)
end

def part_two(input)
  lines = input.split("\n").map!(&:chomp)
  lines.each.map do |line|
    reports = line.split.map(&:to_i)
    evaluate2(reports)
  end.count(true)
end

p part_one(TEST_INPUT) # should be 2
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 4
p part_two(REAL_INPUT)