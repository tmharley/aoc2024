def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day05_testinput.txt')
REAL_INPUT = import_from_file('day05_input.txt')

def part_one(input)
  sum = 0
  rules = {}
  r, s = input.split("\n\n")
  r = r.split("\n").map!(&:chomp)
  r.each do |rule|
    dep, pg = rule.split('|').map!(&:to_i)
    if rules.key?(pg)
      rules[pg] << dep
    else
      rules[pg] = [dep]
    end
  end
  sequences = s.split("\n").map!(&:chomp).map {|seq| seq.split(',').map(&:to_i)}
  sequences.each do |seq|
    valid = true
    seq.each_with_index do |page, i|
      next unless rules.key?(page)
      dependencies = rules[page]
      unfulfilled = dependencies.difference(seq[0...i])
      if unfulfilled.any? && unfulfilled.intersect?(seq)
        valid = false
        break
      end
    end
    sum += seq[seq.size / 2] if valid
  end
  sum
end

def part_two(input)
  sum = 0
  rules = {}
  r, s = input.split("\n\n")
  r = r.split("\n").map!(&:chomp)
  r.each do |rule|
    dep, pg = rule.split('|').map!(&:to_i)
    if rules.key?(pg)
      rules[pg] << dep
    else
      rules[pg] = [dep]
    end
  end
  sequences = s.split("\n").map!(&:chomp).map {|seq| seq.split(',').map(&:to_i)}
  sequences.each do |seq|
    valid = true
    i = 0
    loop do
      break if i >= seq.size
      page = seq[i]
      unless rules.key?(page)
        i += 1
        next
      end
      dependencies = rules[page]
      unfulfilled = dependencies.difference(seq[0...i])
      if unfulfilled.empty?
        i += 1
        next
      end
      if unfulfilled.intersect?(seq)
        valid = false
        item = nil
        j = 0
        while item.nil?
          item = seq.delete(unfulfilled[j])
          j += 1
        end
        seq.insert(i, item)
        i = 0 # restart inspection from the top
      else
        i += 1
      end
    end
    sum += seq[seq.size / 2] unless valid
  end
  sum
end

p part_one(TEST_INPUT) # should be 143
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 123
p part_two(REAL_INPUT)