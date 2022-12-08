@f = $<.map{|line|line.chomp.chars}
@h=@f.size
@w=@f[0].size
# Part 1
v = (0...@h).sum do |y|
	(0...@w).count do |x|
		h0 = @f[y][x]
		(0...x).all?{@f[y][_1]<h0} ||
		(x+1...@w).all?{@f[y][_1]<h0} ||
		(0...y).all?{@f[_1][x]<h0} ||
		(y+1...@h).all?{@f[_1][x]<h0}
	end
end
p v
# Part 2
def vd(x, y, dx, dy)
	c = 0
	h0 = @f[y][x]
	x += dx
	y += dy
	while (0...@w).include?(x) && (0...@h).include?(y) do
		c += 1
		break if @f[y][x] >= h0
		x += dx
		y += dy
	end
	c
end

s = (0...@h).map{|y|
	(0...@w).map{|x|
		vd(x,y,+1,0) * 
		vd(x,y,-1,0) *
		vd(x,y,0,+1) *
		vd(x,y,0,-1)
	}.max
}.max
p s