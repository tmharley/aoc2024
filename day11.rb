def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = '125 17'
REAL_INPUT = import_from_file('day11_input.txt')

def iterate(stones)
  new_stones = {}
  stones.each do |value, count|
    if value == 0
      new_stones.key?(1) ? new_stones[1] += count : new_stones[1] = count
    else
      s = value.to_s
      if s.length.odd?
        new_stones.key?(value * 2024) ? new_stones[value * 2024] += count : new_stones[value * 2024] = count
      else
        left = s[0...s.length / 2].to_i
        right = s[s.length / 2...].to_i
        new_stones.key?(left) ? new_stones[left] += count : new_stones[left] = count
        new_stones.key?(right) ? new_stones[right] += count : new_stones[right] = count
      end
    end
  end
  new_stones
end

def process(input, iterations)
  stones = {}
  input.split(' ').each do |s|
    value = s.to_i
    stones.key?(value) ? stones[value] += 1 : stones[value] = 1
  end
  iterations.times { stones = iterate(stones) }
  stones.values.sum
end

def part_one(input)
  process(input, 25)
end

def part_two(input)
  process(input, 75)
end

p part_one(TEST_INPUT) # should be 55312
p part_one(REAL_INPUT)

p part_two(REAL_INPUT)