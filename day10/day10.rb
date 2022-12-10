input = [*$<]
def xlist(input, one_based_index = false)
	x = 1
	Enumerator.new do |out|
		out << x if one_based_index
		out << x # beginning of cycle 1
		input.each do |line|
			out << x # regardless of opcode, first cycle is the same
			op,arg = line.split
			out << x+=arg.to_i if op == 'addx' # second cycle do add and output new x
		end
		# after this, we just output x (program ended)
		out << x while true
	end
end

# part 1
 p xlist(input, true).with_index.take(221).select{|x,i|(i%40)==20}.sum{|x,i|x*i}

# part2
xlist(input).with_index.take(240).each_slice(40).each do |row|
	puts row.map{|x,i|((i%40)-x).abs <= 1 ? '#' : ' '}.join
end
