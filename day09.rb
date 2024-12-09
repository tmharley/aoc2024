def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = '2333133121414131402'
REAL_INPUT = import_from_file('day09_input.txt')

def part_one(input)
  is_file = true
  id = 0
  sum = 0
  filesystem = []
  input.each_char do |char|
    if is_file
      char.to_i.times { filesystem << id }
      is_file = false
      id += 1
    else
      char.to_i.times { filesystem << nil }
      is_file = true
    end
  end
  (filesystem.size - 1).downto(0) do |i|
    next if filesystem[i] == nil
    break unless (first_free_block = filesystem.index(nil))
    break if first_free_block > i
    filesystem[first_free_block] = filesystem[i]
    filesystem[i] = nil
  end
  filesystem.compact!.each_with_index {|block, index| sum += block * index}
  sum
end

def part_two(input)
  is_file = true
  id = 0
  filesystem = []
  input.each_char do |char|
    if is_file
      filesystem << [id, char.to_i]
      is_file = false
      id += 1
    else
      filesystem << [nil, char.to_i]
      is_file = true
    end
  end
  (filesystem.size - 1).downto(0) do |i|
    file_id, file_size = filesystem[i]
    next if file_id.nil?
    new_loc = filesystem.index {|elem| elem[0] == nil && elem[1] >= file_size}
    next if new_loc.nil? || new_loc > i
    if filesystem[new_loc][1] == file_size
      filesystem[new_loc][0] = file_id
    else
      filesystem[new_loc][1] -= file_size
      filesystem.insert(new_loc, [file_id, file_size])
      i += 1
    end
    filesystem[i][0] = nil
  end
  sum = 0
  loc = 0
  filesystem.each do |elem|
    sum += (loc...loc + elem[1]).sum * elem[0] unless elem[0].nil?
    loc += elem[1]
  end
  sum
end

p part_one(TEST_INPUT) # should be 1928
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 2858
p part_two(REAL_INPUT)