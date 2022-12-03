s = 0
$<.each do |line|
	o,r = line.chomp.split
	x = o.ord-?A.ord
	if r=='X' then
		x = (x+2)%3
	elsif r=='Z'
		x = (x+1)%3
		s+=6
	else
		s+=3
	end
	s+= x+1
end
p s
