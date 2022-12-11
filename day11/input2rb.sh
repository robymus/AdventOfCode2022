#!/bin/sh
(
    echo "def monkey_input"
    echo -e "\t["
    cat day11.input | sed -e "s/.*:$/\t{\n\t\tinspect_count: 0,/" \
                          -e "s/^$/\t},/" \
                          -e "s/.*Starting items: \(.*\)/\t\titems: [\1],/" \
                          -e "s/.*Operation: new = \(.*\)/\t\toperation: ->(old){\1},/" \
                          -e "s/.*Test: divisible by \(.*\)/\t\tdivisible_by: \1,/" \
                          -e "s/.*If \(.*\): throw to monkey \(.*\)/\t\tif_\1: \2,/"
    echo -e "\t}\n\t]"
    echo "end" 
) > day11_input.rb
