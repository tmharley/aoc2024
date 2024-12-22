def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = [1, 10, 100, 2024]
TEST_INPUT_2 = [1, 2, 3, 2024]
REAL_INPUT = import_from_file('day22_input.txt').split("\n").map(&:to_i)

def iterate(old_number)
  n = ((old_number << 6) ^ old_number)[0..23]
  n = ((n >> 5) ^ n)[0..23]
  ((n << 11) ^ n)[0..23]
end

def part_one(input)
  input.map do |n|
    secret = n
    2000.times { secret = iterate(secret) }
    secret
  end.sum
end

def part_two(input)
  price_matrix = Hash.new
  num_monkeys = input.length
  input.each_with_index do |n, monkey|
    secret = n
    last_four_changes = []
    2000.times do
      last_price = secret % 10
      secret = iterate(secret)
      last_four_changes.shift if last_four_changes.size == 4
      last_four_changes << secret % 10 - last_price
      next if last_four_changes.size < 4
      if price_matrix.key?(last_four_changes)
        entry = price_matrix[last_four_changes]
        price_matrix[last_four_changes][monkey] = secret % 10 if entry[monkey].nil?
      else
        price_matrix[last_four_changes.dup] = Array.new(num_monkeys) { |i| secret % 10 if i == monkey }
      end
    end
  end
  price_matrix.sort_by {|k, v| -v.compact!.sum}.first[1].sum
end

p part_one(TEST_INPUT) # should be 37327623
p part_one(REAL_INPUT)

p part_two(TEST_INPUT_2) # should be 23
p part_two(REAL_INPUT)