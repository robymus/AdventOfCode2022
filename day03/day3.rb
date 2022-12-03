require 'set'
p $<.sum{|line|
	line.chomp!
	common=line.chars.each_slice(line.length/2).map(&:to_set).reduce(&:&)
	common.sum{|b|b<?a ? b.ord-?A.ord+27 : b.ord-?a.ord+1}
}