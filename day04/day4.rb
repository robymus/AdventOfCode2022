p $<.count{|line|
	a,b = line.split(',').map{|r|r.split('-').map(&:to_i)}
	a[0]<=b[0]&&a[1]>=b[1] || b[0]<=a[0]&&b[1]>=a[1]
}
