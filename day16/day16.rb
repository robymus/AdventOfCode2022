require 'set'

# "A" => {rate: 10, edge_to:["A", "B"]
$input = {}
$<.each{|line|
	parts = line.chomp.split(/[ =;,]/)
	$input[parts[1]] = 	{rate: parts[5].to_i, edge_to: parts[11..-1].each_slice(2).map(&:first)}
}

# remap this to usable graph - use only non-0 rate, calculate distances and paths between these nodes
# also add AA, so we have our starting point

# breadth first search to all nodes in $nodes
def bfs(start)
	q = [[start,[]]]
	o = $input.keys - [start]
	path = {}
	while q[0] do
		node, p = q.shift
		$input[node][:edge_to].each do |dest_node|
			if o.include? dest_node then
				o -= [dest_node]
				path[dest_node] = p+[dest_node] if $nodes.include? dest_node
				q << [dest_node, p+[dest_node]]
			end
		end
	end
	path
end

# preprocess - we have all relevant nodes and distances to other nodes
$rate = $input.map{|k,v|[k,v[:rate]]}.select{|k,v|k=="AA"||v>0}.to_h
$nodes = $rate.keys.sort
$path = {}
$nodes.each do |node|
	$path[node] = bfs(node)
end

# brute force Part 1
$best = nil
$best_path = nil
def search(open, pos, t, value, pp)
	# try to open the valve if we have time
	search(Set.new(open-[pos]), pos, t-1, value+(t-1)*$rate[pos], pp+'*') if open.include?(pos) && t>0 && $rate[pos]>0
	# go over the possible targets, if we have time
	$path[pos].each do |dest, path|
		if t > path.size && open.include?(dest) then
			search(open, dest, t-path.size, value, pp+dest)
		end
	end
	# we tried everything possible
	if !$best || value > $best then
		$best = value
		$best_path = pp
		puts "#{pp} -> #{value}"
	end
end

search($nodes.to_set-['AA'], 'AA', 30, 0, 'AA')
puts $found.values.max