# lazy to write parser for the stacks
stacks = [
	"ZJG",
	"QLRPWFVC",
	"FPMCLGR",
	"LFBWPHM",
	"GCFSVQ",
	"WHJZMQTL",
	"HFSBV",
	"FJZS",
	"MCDPFHBT"
].map(&:chars)

$<.each do |line|
	m = line.match(/move (\d+) from (\d+) to (\d+)/)
	next if not m
	cnt = m[1].to_i
	from = m[2].to_i
	to = m[3].to_i
	stacks[to-1].push(*stacks[from-1].pop(cnt))
end
puts stacks.map(&:last).join
