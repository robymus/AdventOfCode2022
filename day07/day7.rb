# build dir tree from input
def mkdir(cwd, dir)
	if !cwd[:children][dir] then
		cwd[:children][dir] = {
			parent: cwd,
			children: {},
			size: 0
		}
	end
end	

def mkfile(cwd, fn, size)
	if !cwd[:children][fn] then
		cwd[:children][fn] = {
			parent: cwd,
			children: nil,
			size: size
		}
		dir = cwd
		while dir do
			dir[:size] += size
			dir = dir[:parent]
		end
	end
end

root = {
	parent: nil,
	children: {},	# if nil, it is a file, otherwise indexed by name
	size: 0
}
cwd = root
$<.each{|line|
	is_cd = line.match(/^\$ cd (.*)/)	# cd creates directory or traverses tree
	if is_cd then
		dir = is_cd[1]
		case dir
		when '/'
			cwd = root
		when '..'
			cwd = cwd[:parent] || root
		else
			mkdir(cwd, dir)
			cwd = cwd[:children][dir]
		end
		next
	end
	next if line =~ /^\$ ls/	# ls is boring, we skip it :)
	is_dir = line.match(/^dir (.*)/)
	if is_dir then
		dir = is_dir[1]
		mkdir(cwd, dir)
		next
	end
	is_file = line.match(/^(\d+) (.*)/)
	if is_file then
		size = is_file[1].to_i
		fn = is_file[2]
		mkfile(cwd, fn, size)
	end
	# we covered all cases
}

# debug dump
def dump(node, indent)
	node[:children].each do |name, child|
		if child[:children] then
			puts "#{indent}#{name}/ size=#{child[:size]}"
			dump(child, indent+'  ')
		else
			puts "#{indent} #{name} size=#{child[:size]}"
		end
	end
end
# dump(root, '')

# Part 1
def part1_dfs(node)
	return 0 if !node[:children] # not counting files
	sum = node[:size] <= 100000 ? node[:size] : 0
	return sum + node[:children].sum{|name,child|part1_dfs(child)}
end
p part1_dfs(root)

# Part 2
def part2_dir_sizes(node)
	return [] if !node[:children] # not counting files	
	return [node[:size]].concat(*node[:children].map{|name,child|part2_dir_sizes(child)})
end
required_size = root[:size]-40000000
p part2_dir_sizes(root).sort.find{|s|s >= required_size}