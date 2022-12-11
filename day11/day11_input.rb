def monkey_input
	[
	{
		inspect_count: 0,
		items: [73, 77],
		operation: ->(old){old * 5},
		divisible_by: 11,
		if_true: 6,
		if_false: 5,
	},
	{
		inspect_count: 0,
		items: [57, 88, 80],
		operation: ->(old){old + 5},
		divisible_by: 19,
		if_true: 6,
		if_false: 0,
	},
	{
		inspect_count: 0,
		items: [61, 81, 84, 69, 77, 88],
		operation: ->(old){old * 19},
		divisible_by: 5,
		if_true: 3,
		if_false: 1,
	},
	{
		inspect_count: 0,
		items: [78, 89, 71, 60, 81, 84, 87, 75],
		operation: ->(old){old + 7},
		divisible_by: 3,
		if_true: 1,
		if_false: 0,
	},
	{
		inspect_count: 0,
		items: [60, 76, 90, 63, 86, 87, 89],
		operation: ->(old){old + 2},
		divisible_by: 13,
		if_true: 2,
		if_false: 7,
	},
	{
		inspect_count: 0,
		items: [88],
		operation: ->(old){old + 1},
		divisible_by: 17,
		if_true: 4,
		if_false: 7,
	},
	{
		inspect_count: 0,
		items: [84, 98, 78, 85],
		operation: ->(old){old * old},
		divisible_by: 7,
		if_true: 5,
		if_false: 4,
	},
	{
		inspect_count: 0,
		items: [98, 89, 78, 73, 71],
		operation: ->(old){old + 4},
		divisible_by: 2,
		if_true: 3,
		if_false: 2,
	}
	]
end
