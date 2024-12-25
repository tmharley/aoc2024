def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day25_testinput.txt')
REAL_INPUT = import_from_file('day25_input.txt')

class LockComponent
  attr_reader :heights
  @heights = [0, 0, 0, 0, 0]

  def initialize(heights)
    @heights = heights
  end

  def max_height
    @heights.max
  end
end

class Lock < LockComponent

end

class Key < LockComponent
  def fits_lock?(lock)
    @heights.zip(lock.heights).map(&:sum).none? { |s| s > 5 }
  end
end

def build_component(input)
  type = input.first == '#####' ? Lock : Key
  heights = Array.new(5) { 0 }
  lookup = (type == Lock ? input : input.reverse)
  (1...lookup.length).each do |i|
    (0..4).each do |j|
      heights[j] = i - 1 if lookup[i][j] != lookup[i - 1][j]
    end
  end
  type.new(heights)
end

def part_one(input)
  valid_combos = 0
  locks = []
  keys = []
  input.split("\n\n").each do |component_def|
    component = build_component(component_def.split("\n"))
    (component.is_a?(Lock) ? locks : keys) << component
  end
  keys.each do |key|
    locks.each do |lock|
      valid_combos += 1 if key.fits_lock?(lock)
    end
  end
  valid_combos
end

p part_one(TEST_INPUT) # should be 3
p part_one(REAL_INPUT)