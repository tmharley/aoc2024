def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day17_testinput.txt')
TEST_INPUT_2 = import_from_file('day17_testinput2.txt')
REAL_INPUT = import_from_file('day17_input.txt')

def combo_operand(operand, registers)
  case operand
  when 0..3
    operand
  when 4..6
    registers[operand - 4]
  else
    raise 'Invalid combo operand'
  end
end

def process(instruction, operand, registers, pointer, output)
  case instruction
  when 0
    registers[0] = registers[0] / 2 ** combo_operand(operand, registers)
    pointer + 2
  when 1
    registers[1] = registers[1] ^ operand
    pointer + 2
  when 2
    registers[1] = combo_operand(operand, registers) % 8
    pointer + 2
  when 3
    registers[0].zero? ? pointer + 2 : operand
  when 4
    registers[1] = registers[1] ^ registers[2]
    pointer + 2
  when 5
    output << combo_operand(operand, registers) % 8
    pointer + 2
  when 6
    registers[1] = registers[0] / 2 ** combo_operand(operand, registers)
    pointer + 2
  when 7
    registers[2] = registers[0] / 2 ** combo_operand(operand, registers)
    pointer + 2
  else
    raise 'Invalid instruction'
  end
end

def part_one(input)
  lines = input.split("\n")
  a = lines[0].split(': ')[1].to_i
  b = lines[1].split(': ')[1].to_i
  c = lines[2].split(': ')[1].to_i
  registers = [a, b, c]
  ptr = 0
  output = []
  program = lines[4].split(': ')[1].split(',').map(&:to_i)
  while ptr < program.length
    ptr = process(program[ptr], program[ptr + 1], registers, ptr, output)
  end
  output.join(',')
end

def part_two(input)
  lines = input.split("\n")
  check_values = (0..7).to_a.zip([1] * 8, Array.new(8))
  candidates = []
  starting_b = lines[1].split(': ')[1].to_i
  starting_c = lines[2].split(': ')[1].to_i
  output = []
  program = lines[4].split(': ')[1].split(',').map(&:to_i)
  loop do
    starting_a, check_digits = check_values.shift
    registers = [starting_a, starting_b, starting_c]
    output.clear
    ptr = 0
    while ptr < program.length
      ptr = process(program[ptr], program[ptr + 1], registers, ptr, output)
    end
    if output == program
      candidates << starting_a
    elsif output[-check_digits...] == program[-check_digits...]
      (0..7).each do |n|
        check_values.push([starting_a * 8 + n, check_digits + 1, output.dup])
      end
    end
    break if check_values.empty?
  end
  candidates.min
end

p part_one(TEST_INPUT) # should be "4,6,3,5,6,3,5,2,1,0"
p part_one(REAL_INPUT)

p part_two(TEST_INPUT_2) # should be 117440
p part_two(REAL_INPUT)