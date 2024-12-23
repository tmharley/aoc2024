def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day23_testinput.txt')
REAL_INPUT = import_from_file('day23_input.txt')

def build_network(connections)
  network = {}
  connections.each do |connection|
    c1, c2 = connection.split('-')
    network.key?(c1) ? network[c1] << c2 : network[c1] = [c2]
    network.key?(c2) ? network[c2] << c1 : network[c2] = [c1]
  end
  network
end

def part_one(input, start_letter = nil)
  sets = Set.new
  network = build_network(input.split("\n"))
  valid_networks = start_letter ? network.select { |k, _| k.start_with?(start_letter) } : network
  valid_networks.each do |first, v|
    v.each do |second|
      thirds = network[second].select { |conn| v.include?(conn) }
      thirds.each do |third|
        sets << [first, second, third].sort
      end
    end
  end
  [sets, network]
end

def combine_sets(sets, network)
  additions_made = false
  sets.each do |set|
    network.each do |k, v|
      next if set.include?(k)
      if set.intersection(v) == set
        set << k
        additions_made = true
      end
    end
  end
  additions_made
end

def part_two(input)
  sets, network = part_one(input)
  while combine_sets(sets, network)
    p "Changes made, continuing to process"
  end
  sets.sort_by { |s| -s.size }.first.sort.join(',')
end

p part_one(TEST_INPUT, 't')[0].size # should be 7
p part_one(REAL_INPUT, 't')[0].size

p part_two(TEST_INPUT) # should be "co,de,ka,ta"
p part_two(REAL_INPUT)