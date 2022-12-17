input = gets.chomp

# bottom-up order, first in pat goes to bottom
# also right-left order, eg least significant bit is left
rocks = [
    {
        pat:[ 0b1111 ],
        mask: 0b1111
    },
    {
        pat:[ 0b010,
              0b111,
              0b010 ],
        mask: 0b111
    },
    {
        pat:[ 0b111,
              0b100,
              0b100 ],
        mask: 0b111
    },
    {
        pat:[ 0b1,
              0b1,
              0b1,
              0b1 ],
        mask: 0b1
    },
    {
        pat:[ 0b11,
              0b11 ],
        mask: 0b11
    }
]

# put a floor in for easier checking
$cave = [0b1111111]
top = 0 # top row in the cave filled
ri = 0 # position in rocks
ii = 0 # position in input

def check_collission(rb, pat, sh)
    i = 0
    while i < pat.size && rb+i < $cave.size do
        return true if ($cave[rb+i] & (pat[i] << sh)) != 0
        i += 1
    end
    false # no collision so far
end

# Part 1: run sim 2022 times
# this is absolutely not suitable for part 2, some kind of trick is needed :)
2022.times do |cnt|
    rock = rocks[ri]
    ri = (ri+1) % rocks.size
    pos = 2 # from the left in the cave
    rb = top + 4
    rock_can_fall = true
    while rock_can_fall do
        # wind
        w = input[ii]
        ii = (ii+1) % input.size
        pos -= 1 if w == '<' && pos > 0 && !check_collission(rb, rock[:pat], pos-1)
        pos += 1 if w == '>' && (rock[:mask] << pos)&0x40 == 0 && !check_collission(rb, rock[:pat], pos+1)
        # fall
        rock_can_fall = !check_collission(rb-1, rock[:pat], pos)
        rb -= 1 if rock_can_fall
    end
    # arrived at bottom, let's add put it there
    (0...rock[:pat].size).each do |i|
        $cave << 0 while rb+i >= $cave.size
        $cave[rb+i] |= rock[:pat][i] << pos
        top = [top, rb+i].max
    end
    # puts
    # puts $cave[1..-1].reverse.map{("%07b"%_1).reverse.tr('01','.#')}
end
p top