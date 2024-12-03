def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))'
TEST_INPUT_2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

REAL_INPUT = import_from_file('day03_input.txt')

def part_one(input)
  total = 0
  index = 0
  loop do
    match = /mul\((\d+),(\d+)\)/.match(input, index)
    break if match.nil?
    index = match.end(0)
    total += match[1].to_i * match[2].to_i
  end
  total
end

def part_two(input)
  total = 0
  index = 0
  process = true
  loop do
    match = /(mul|don't|do)\((\d*)(,?)(\d*)\)/.match(input, index)
    break if match.nil?
    index = match.end(0)
    case match[1]
    when 'mul'
      total += match[2].to_i * match[4].to_i if process && match[3] == ','
    when 'do'
      process = true
    when "don't"
      process = false
    end
  end
  total
end

p part_one(TEST_INPUT) # should be 161
p part_one(REAL_INPUT)

p part_two(TEST_INPUT_2) # should be 48
p part_two(REAL_INPUT)