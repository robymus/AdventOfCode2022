require 'set'
input = $<.map{|line|line.split(',').map(&:to_i)}

# filled positions in space (indexed by [x,y,z])
filled = Set.new

# Part 1
surface = 0
# calculate bounds
bl = input[0].clone
bh = input[0].clone
input.each do |coords|
	x,y,z = coords
	blocked_faces = 0
	[-1,+1].each do |d|
		blocked_faces +=1 if filled.include? [x+d,y,z]
		blocked_faces +=1 if filled.include? [x,y+d,z]
		blocked_faces +=1 if filled.include? [x,y,z+d]
	end
	filled << coords
	surface += 6 - 2 * blocked_faces
	# calculate bounds
	3.times do |i|
		bl[i] = [bl[i],coords[i]].min
		bh[i] = [bh[i],coords[i]].max
	end
end
p surface

# Part 2 - find inside cubes - floodfill from corner
range = bl.zip(bh).map{(_1-1)..(_2+1)}
openset = [bl.map{_1-1}] # start from lowest corner -1
closedset = Set.new
xsurface = 0
while openset[0] do
	cur = openset.shift
	closedset << cur
	x,y,z = cur
	neighbours = [
		[x-1,y,z],
		[x+1,y,z],
		[x,y-1,z],
		[x,y+1,z],
		[x,y,z-1],
		[x,y,z+1]
	].select{|c|range.zip(c).all?{_1===_2}} # those in range
	neighbours.each do |n|
		if filled.include?(n) then
			xsurface += 1 # neighbour is filled
		elsif !closedset.include?(n) && !openset.include?(n) then
			openset << n
		end
	end
end
p xsurface