def import_from_file(filename)
  file = File.open(filename)
  file.read
end

TEST_INPUT = import_from_file('day20_testinput.txt')
REAL_INPUT = import_from_file('day20_input.txt')

class RaceCourse
  def initialize(input)
    @grid = Array.new
    @cheat_distance = {}
    input.split("\n").each_with_index do |line, y|
      @grid << (row = Array.new)
      (0...line.length).each do |x|
        case line[x]
        when 'S'
          @start = [x, y]
          row << 0
        when 'E'
          @end = [x, y]
          row << -1
        when '#'
          row << nil
        else
          row << -1
        end
      end
    end
    x, y = *@start
    dist = 0
    begin
      location = move(x, y, dist)
      dist += 1
      x, y = *location
    end while location
  end

  def move(location_x, location_y, distance)
    @grid[location_y][location_x] = distance
    return nil if @end == [location_x, location_y]
    if location_x < @grid.size - 1 && @grid[location_y][location_x + 1] == -1
      [location_x + 1, location_y]
    elsif location_y < @grid.size - 1 && @grid[location_y + 1][location_x] == -1
      [location_x, location_y + 1]
    elsif location_x > 0 && @grid[location_y][location_x - 1] == -1
      [location_x - 1, location_y]
    else
      [location_x, location_y - 1]
    end
  end

  def cheat_distance(origin, dest, maximum)
    @cheat_distance.clear
    cp = cheat_path(origin, dest, 0, maximum)
    cp.nil? ? nil : @grid[dest[1]][dest[0]] - @grid[origin[1]][origin[0]] - cp
  end

  def cheat_path(origin, dest, distance, maximum)
    return nil if distance > maximum
    if origin == dest
      @cheat_distance[dest] = distance
      return distance
    end
    if origin[0] < @grid.size - 1
      east = [origin[0] + 1, origin[1]]
      found = cheat_path(east, dest, distance + 1, maximum) if (@grid[east[1]][east[0]].nil? || east == dest) && (!@cheat_distance.key?(east) || @cheat_distance[east] > distance + 1)
      return found if found
    end
    if origin[1] < @grid.size - 1
      south = [origin[0], origin[1] + 1]
      found = cheat_path(south, dest, distance + 1, maximum) if (@grid[south[1]][south[0]].nil? || south == dest) && (!@cheat_distance.key?(south) || @cheat_distance[south] > distance + 1)
      return found if found
    end
    if origin[0] > 0
      west = [origin[0] - 1, origin[1]]
      found = cheat_path(west, dest, distance + 1, maximum) if (@grid[west[1]][west[0]].nil? || west == dest) && (!@cheat_distance.key?(west) || @cheat_distance[west] > distance + 1)
      return found if found
    end
    if origin[1] > 0
      north = [origin[0], origin[1] - 1]
      found = cheat_path(north, dest, distance + 1, maximum) if (@grid[north[1]][north[0]].nil? || north == dest) && (!@cheat_distance.key?(north) || @cheat_distance[north] > distance + 1)
      return found if found
    end
    nil
  end

  def find_cheats(threshold, max_cheat_length)
    cheats = Set.new
    (0...@grid.size).each do |y|
      (0...@grid[y].size).each do |x|
        if @grid[y][x]
          candidates = Array.new
          (0...@grid.size).each do |yy|
            (0...@grid[yy].size).each do |xx|
              candidates << [xx, yy] if @grid[yy][xx] && !(x == xx && y == yy) && (x - xx).abs + (y - yy).abs <= max_cheat_length
            end
          end
          candidates.each do |candidate|
            dist = @grid[candidate[1]][candidate[0]] - @grid[y][x] - ((candidate[0] - x).abs + (candidate[1] - y).abs)
            cheats << {from: [x, y], to: candidate, saved: dist} if dist && dist >= threshold
          end
        end
      end
    end
    cheats
  end
end

def part_one(input, threshold)
  RaceCourse.new(input).find_cheats(threshold, 2).size
end
def part_two(input, threshold)
  RaceCourse.new(input).find_cheats(threshold, 20).size
end

p part_one(TEST_INPUT, 1) # should be 44 total cheats
p part_one(REAL_INPUT, 100)

p part_two(TEST_INPUT, 50) # should be 285
p part_two(REAL_INPUT, 100)