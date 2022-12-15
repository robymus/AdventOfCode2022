input = $<.map{|line|line.scan(/-?\d+/).map(&:to_i)}

def to_intervals(input, y)
	intervals = [] # actual [position, +/-1]
	input.each do |sx, sy, bx, by|
		md = (sx-bx).abs+(sy-by).abs
		mdy = (sy-y).abs
		mdx = md-mdy.abs # ([sx-mdx,sx+mdx) is not possible (because ties also not possible)
		next if (mdy > md)
		intervals << [sx-mdx, 1]
		intervals << [sx+mdx, -1]
	end
	intervals.sort
end

# part 1
intervals = to_intervals(input, 2000000)
d = 0
x = intervals[0][0]
not_possible = 0
intervals.each do |ix, id|
	not_possible += ix-x if d > 0
	d += id
	x = ix
end
puts "Part 1: #{not_possible}"

# part 2 (quite slow, because ruby, done in 53 secs)
(0..4000000).each do |y|
	puts "..#{y/40000.0}%" if y % 100000 == 0
	intervals = to_intervals(input, y)
	d = 0
	x = intervals[0][0]
	intervals.each do |ix, id|
		# check if found
		if d == 0 && (ix-x)>0 && (ix-1)>=0 && (ix-1) <= 4000000 then			
			puts "#{ix-1},#{y} -> #{(ix-1)*4000000 + y}"
			exit
		end
		d += id
		x = ix
	end
end
puts "Not found"