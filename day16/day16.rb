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

# Part 1

# exhaustive search with simple heuristics
$best = nil
$collect_solutions = false
def search(open, pos, t, value)
	possible_target = $path[pos].select{|dest, path|path.size<=t-1 && open.include?(dest)}
	possible_target.each do |dest, path|		
		search(open - [dest], dest, t-path.size-1, value + (t-path.size-1)*$rate[dest])
	end
	# we tried everything possible
	if !$best || value > $best then
		$best = value
		$best_path = pp
	end
	# collect solitions by open set, keep best value for each closed set
	if $collect_solutions then
		k = $full_set-open.to_set
		if $all_solutions[k] then
			$all_solutions[k] = [$all_solutions[k], value].max
		else
			$all_solutions[k] = value
		end
	end
end

search($nodes-['AA'], 'AA', 30, 0)
puts "Part 1:"
puts $best

# Part 2
$best = nil
$collect_solutions = true
$full_set = ($nodes-['AA']).to_set
$all_solutions = {}
# collect all solutions, indexed by open set
search($nodes-['AA'], 'AA', 26, 0)
# find the best combination
# it's a little slow, ~25 sec, still acceptable
puts "Part 2:"
p $all_solutions.keys.combination(2).select{|s1, s2|(s1&s2).empty?}.map{|s1,s2|$all_solutions[s1]+$all_solutions[s2]}.max
