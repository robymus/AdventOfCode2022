e=[]
buf=[]
$<.each do |line|
	if line=="\n" then
		e<<buf
		buf=[]
	else
		buf<<line.to_i
	end
end
e<<buf if buf[0]
p e.map(&:sum).max
p e.map(&:sum).sort.reverse[0..2].sum
