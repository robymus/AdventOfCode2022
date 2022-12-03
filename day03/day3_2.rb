require 'set'
p $<.each_slice(3).sum{|group|
	common=group.map{|line|line.chomp.chars.to_set}.reduce(&:&)
	common.sum{|b|b<?a ? b.ord-?A.ord+27 : b.ord-?a.ord+1}
}