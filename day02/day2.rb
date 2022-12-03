s = 0
$<.each do |line|
	o,m = line.chomp.split
	s+=1 if m == 'X'
	s+=2 if m == 'Y'
	s+=3 if m == 'Z'
	if (o=='A'&&m=='X')||(o=='B'&&m=='Y')||(o=='C'&&m=='Z') then
		s += 3
	elsif (o=='A'&&m=='Y')||(o=='B'&&m=='Z')||(o=='C'&&m=='X')
		s += 6
	end
end
p s
