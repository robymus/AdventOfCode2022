require 'set'

m = $<.map{|line|line.chomp.bytes}
h = m.size
w = m[0].size
start = []
finish = []
# find start and end and replace with a/z + init q
# reverse start and finish, for the sake of part 2, as for part 1 it doesn't matter
q = []
(0...w).each do |x|
	(0...h).each do |y|
		m[y][x],finish = 'a'.ord,[x,y] if m[y][x] == 'S'.ord
		m[y][x],start = 'z'.ord,[x,y] if m[y][x] == 'E'.ord
		q << [x,y]
	end
end
# init dist/prev
INF = w*h*2
dist = Array.new(h) {Array.new(w, INF)}
prev = Array.new(h) {Array.new(w, nil)}
dist[start[1]][start[0]] = 0
# unoptimized dijkstra ftw - O(n^2*log n)
while q[0] do
	q.sort_by!{|a|x,y=a;dist[y][x]}
	x,y = q.shift
	d = dist[y][x]
	h1 = m[y][x]-1
	[ [0,1],[0,-1],[1,0],[-1,0] ].each do |dx,dy|
		nx = x+dx
		ny = y+dy
		if nx >= 0 && nx < w && ny >=0 && ny < h && m[ny][nx] >= h1 && q.include?([nx,ny]) then
			ndist = d+1
			dist[ny][nx],prev[ny][nx] = ndist, [x,y] if ndist < dist[ny][nx]
		end
	end
end

# Part 1
p dist[finish[1]][finish[0]]

# Part 2
p (0...w).to_a.product((0...h).to_a).map{|c|x,y=c;m[y][x] == 'a'.ord ? dist[y][x] : INF}.min
