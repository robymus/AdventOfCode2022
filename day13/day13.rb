load './day13_input.rb'

def compare(left, right)
	while left[0] && right[0] do
		l = left.shift
		r = right.shift
		la = l.kind_of?(Array)
		ra = r.kind_of?(Array)
		if la && ra then
			r = compare(l, r)
			return r if r != 0
		elsif !la && !ra then
			r = l <=> r
			return r if r != 0
		elsif la && !ra then
			left.prepend(l)
			right.prepend([r])
		else # !la && ra
			left.prepend([l])
			right.prepend(r)
		end
	end
	return 0 if left.empty? && right.empty?
	return -1 if left.empty?
	return +1 if right.empty?
end

# Part 1
p day13input.each_slice(2).each_with_index.select{|pair,i|compare(*pair) < 0}.map{|r,i|i+1}.sum
# Part 2
less_than_2 = day13input.count{|i|compare(i,[[2]])<0}
less_than_6 = day13input.count{|i|compare(i,[[6]])<0}
p (less_than_2+1)*(less_than_6+2)
