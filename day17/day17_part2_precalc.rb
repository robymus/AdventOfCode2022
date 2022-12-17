#
# The idea is the following
# - checked some millions of steps and the new piece always ands up on the top, first layer or second layer
# - in theory it could be deeper (like a | falling in a hole) but it doesn't happen (i guess)
# - the top 2 layer defines the state (2x7 bits)
# - during this fall, it might change position at most 6 times, that's 6 extra bits for possible directions
# - there are 5 pieces
# - total number of possible input states: 5<<20 (~5 million)
# - we can do the simulation for all states, and store
#   - output state (14 bits)
#   - number of steps to advance input (3 bits, at most 6)
#   - number to increase top by (3 bits, at most 4)
# - that fits in 32 bits, so we can have a big table with 5 million elements, 4 bytes each, very reasonable
# - convert input into 6 bit values starting at each index
# - then we can iterate quickly through the 1 trillion states, probably in less than an hour :)
#
# Because the part 1 code is ready, I will reuse it to generate the table, then include it from C++, and we are good to go
#
# And then we write a c++ header for the real performance to happen there :)
#
# Runtime: 18 seconds
#

input = gets.chomp

# convert input into bitstring
# i'm lazy to parse anything in c++ :)
File.open('pregen_input.h', 'w') do |f|
    f.write("constexpr int input_length=#{input.length};\n")
    f.write("// preshifted by 14 bits left for easy lookup\n")
    f.write("const unsigned int input_bits[] = {\n")
    ii = input+input[0,32] # add 32 extra, actually we need only +5 (for loop unrolling) and +6 (for going over the end)
    (0..input.length+5).each do |start|
        s = ii[start,6]
        f.write"\t0x#{"%08x"%(s.tr('<>','01').to_i(2) << 14)},\n" #
    end
    f.write "};\n"
end

exit if File.exists?('pregen_lookup.h')

# bottom-up order, first in pat goes to bottom
# also right-left order, eg least significant bit is left
rocks = [
    {
        name: "-",
        pat:[ 0b1111 ],
        mask: 0b1111
    },
    {
        name: "^",
        pat:[ 0b010,
              0b111,
              0b010 ],
        mask: 0b111
    },
    {
        name: "L",
        pat:[ 0b111,
              0b100,
              0b100 ],
        mask: 0b111
    },
    {
        name: "|",
        pat:[ 0b1,
              0b1,
              0b1,
              0b1 ],
        mask: 0b1
    },
    {
        name: "#",
        pat:[ 0b11,
              0b11 ],
        mask: 0b11
    }
]

def check_collission(rb, pat, sh)
    i = 0
    while i < pat.size && rb+i < $cave.size do
        return true if ($cave[rb+i] & (pat[i] << sh)) != 0
        i += 1
    end
    false # no collision so far
end

def outpattern(f, dest_line1, dest_line2, input_shift, top_increase)
    val = (dest_line1<<7) | dest_line2 | (input_shift << 16) | (top_increase << 24)
    f.write("\t0x%08x,\n" % val)
end

File.open('pregen_lookup.h', 'w') do |f|
    f.write("const unsigned int lookup_table[] = {\n")
    rocks.each do |rock|
        (1<<6).times do |input_bits|
            input = ("%06b"%input_bits).tr('01','<>');
            f.write("// Rock: %s Wind: %s\n" % [rock[:name], input]);
            puts "Rock: %s Wind: %s" % [rock[:name], input]
            # go through all possible starting position
            (1<<14).times do |start_state|
                line1 = start_state >> 7
                line2 = start_state & 0x7f
                redirect = false
                redirect, line1, line2 = true, 0x7f, 0x7f if start_state == 0
                redirect, line1, line2 = true, line2, 0x7f if line1 == 0 # this is an illegal state (top line empty) -> redirect
                redirect, line2 = true, 0x7f if line2 == 0 # this is an illegal state, second line empty -> redirect
                if redirect then
                    # just fill the table with this state
                    outpattern(f, line1, line2, 0, 0)
                    next
                end
                # not a redirect, do the simulation
                $cave = [line2, line1]
                top = 1
                ii = 0
                pos = 2 # from the left in the cave
                rb = top + 4
                rock_can_fall = true
                while rock_can_fall do
                    # wind
                    w = input[ii]
                    ii += 1
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
                # all good
                outpattern(f, $cave[top], $cave[top-1], ii, top-1)
            end
            
        end
    end
    f.write("};\n");
end