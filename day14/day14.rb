input = $<.map{|line|line.split(' -> ').map{|coords|coords.split(',').map(&:to_i)}}
# find bounding box, always containing sand input point
bx0, by0, bx1, by1 = 500, 0, 500, 0
input.each do |path|
	path.each do |coords|
		bx0 = [bx0, coords[0]].min
		bx1 = [bx1, coords[0]].max
		by0 = [by0, coords[1]].min
		by1 = [by1, coords[1]].max
	end
end
# allocate / fill map
def init_map(input, bx0, by0, bx1, by1)	
	w = bx1-bx0+1
	h = by1-by0+1
	m = Array.new(h){Array.new(w){nil}}
	input.each do |partition|
		sx, sy = partition[0]
		m[sy-by0][sx-bx0] = '#'
		partition[1..-1].each do |dx, dy|
			stepx = dx <=> sx
			stepy = dy <=> sy
			while sx != dx || sy != dy do
				sx += stepx
				sy += stepy
				m[sy-by0][sx-bx0] = '#'
			end
		end
	end
	m
end

# Part 1 simulation
m = init_map(input, bx0, by0, bx1, by1)
sand_in = true
counter = 0
while sand_in do
	sx, sy = 500, 0
	while sand_in=(sx >= bx0 && sx <= bx1 && sy < by1) do
		if !m[sy+1-by0][sx-bx0] then
			sy+=1
		elsif sx==bx0 || !m[sy+1-by0][sx-1-bx0] then
			sy+=1
			sx-=1
		elsif sx==bx1 || !m[sy+1-by0][sx+1-bx0] then
			sy+=1
			sx+=1
		else
			m[sy-by0][sx-bx0] = 'o'
			counter += 1
			break
		end
	end
end
# puts m.map{|line|line.map{_1||'.'}.join}
p counter

# Part 2 simulation
# Infinity is too far, let's bound it - worst case, we are building a big pyramid, it spreads 'height' both directions
# and of course we are adding +-2 for safety :)
bx0 = [500-by1-2,bx0].min
bx1 = [500+by1+2,bx1].max
by1 += 2
m = init_map(input, bx0, by0, bx1, by1)
# fill up the last line with wall
m[-1].map!{'#'}
counter = 0
while !m[0-by0][500-bx0] do
	sx, sy = 500, 0
	while true do
		if !m[sy+1-by0][sx-bx0] then
			sy+=1
		elsif !m[sy+1-by0][sx-1-bx0] then
			sy+=1
			sx-=1
		elsif !m[sy+1-by0][sx+1-bx0] then
			sy+=1
			sx+=1
		else
			m[sy-by0][sx-bx0] = 'o'
			counter += 1
			break
		end
	end
end
# puts m.map{|line|line.map{_1||'.'}.join}
p counter
