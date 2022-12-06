signal = gets.chomp.chars
# Magic
magic=->(signal,s){(s..signal.length).find{|i|signal[i-s,s].uniq.size==s}}
# Part 1
p magic[signal, 4]
# Part 2
p magic[signal, 14]

