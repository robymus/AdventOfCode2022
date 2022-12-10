require 'set'
h = [0,0]
t = [0,0]
visited = [t].to_set
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
		h[0] += d[0]
		h[1] += d[1]
		if (h[0]-t[0]).abs > 1 || (h[1]-t[1]).abs > 1 then 
			t = [
				t[0] + (h[0]-t[0] <=> 0), # sgn
				t[1] + (h[1]-t[1] <=> 0) # sgn
			] # this is just magic, so not the same reference is store in the set, but a new copy
			visited << t
		end
	end
end
# part 1
p visited.size
