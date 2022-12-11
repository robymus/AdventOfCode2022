load './day11_input.rb'

def monkey_business(worry_div_by, rounds)
  monkey = monkey_input
  worry_mod_by = monkey.map{|m|m[:divisible_by]}.inject(&:*)
  rounds.times do |r|
    monkey.each do |m|
      while item = m[:items].shift do
        worry = (m[:operation][item] / worry_div_by) % worry_mod_by
        m[:inspect_count] += 1
        dest = worry % m[:divisible_by] == 0 ? m[:if_true] : m[:if_false]
        monkey[dest][:items] << worry
      end
    end
  end
  monkey.map{|m|m[:inspect_count]}.sort[-2,2].inject(&:*)
end

# Part 1
p monkey_business(3, 20)

# Part 2
p monkey_business(1, 10000)
