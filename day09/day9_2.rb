require 'set'
@len = 10
@h = [[0,0]]*@len
@visited = [@h[-1]].to_set
# move chain point i by d
def move(i, d)
	@h[i] = [
		@h[i][0] + d[0],
		@h[i][1] + d[1]
	]
	if i == @len-1 then
		@visited << @h[i]
	else
		dx = @h[i][0]-@h[i+1][0]
		dy = @h[i][1]-@h[i+1][1]
		if dx.abs > 1 || dy.abs > 1 then 
			move(i+1, [dx <=> 0, dy <=> 0])
		end
	end
end

# simulate
$<.each do |line|
	dir,c = line.split
	c = c.to_i
	case dir
	when 'R'
		d = [+1, 0]
	when 'L'
		d = [-1, 0]
	when 'U'
		d = [0, -1]
	when 'D'
		d = [0, +1]
	else
		puts "Error: #{line}"
		exit 
	end
	c.times do
		move(0, d)
	end
end
# part 2
p @visited.size
