def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day07_testinput.txt')
REAL_INPUT = import_from_file('day07_input.txt')

class TargetValueFoundException < Exception; end

def evaluate(start, operator, operand_list, target, allow_concat: false)
  if operand_list.empty?
    raise TargetValueFoundException if start == target
    return
  end
  if operator == '||'
    result = "#{start}#{operand_list.first}".to_i
  else
    result = start.method(operator).call(operand_list.first)
  end
  evaluate(result, :+, operand_list[1...], target, allow_concat: allow_concat)
  evaluate(result, :*, operand_list[1...], target, allow_concat: allow_concat)
  evaluate(result, '||', operand_list[1...], target, allow_concat: allow_concat) if allow_concat
end

def part_one(input)
  total = 0
  equations = input.split("\n").map!(&:chomp)
  equations.each do |eq|
    t, o = eq.split(': ')
    target = t.to_i
    operands = o.split(' ').map!(&:to_i)
    begin
      evaluate(operands.first, :+, operands[1...], target)
      evaluate(operands.first, :*, operands[1...], target)
    rescue TargetValueFoundException
      total += target
    end
  end
  total
end

def part_two(input)
  total = 0
  equations = input.split("\n").map!(&:chomp)
  equations.each do |eq|
    t, o = eq.split(': ')
    target = t.to_i
    operands = o.split(' ').map!(&:to_i)
    begin
      evaluate(operands.first, :+, operands[1...], target, allow_concat: true)
      evaluate(operands.first, :*, operands[1...], target, allow_concat: true)
      evaluate(operands.first, '||', operands[1...], target, allow_concat: true)
    rescue TargetValueFoundException
      total += target
    end
  end
  total
end

p part_one(TEST_INPUT) # should be 3749
p part_one(REAL_INPUT)

p part_two(TEST_INPUT) # should be 11387
p part_two(REAL_INPUT)