
module ScoreHelper
	
	# Score sheet template. Has three sections: top, bottom and grand_total. Each section has scorig options
	#
	def score_template
		{top: {aces: 0, twos: 0, threes: 0, fours: 0, fives: 0, sixes: 0, number_totals: 0, 
													bonus: 0, total: 0},
		 bottom: {three_of_a_kind: 0, four_of_a_kind: 0, full_house: 0, sm_straight: 0, 
														lg_straight: 0, yahtzee: 0, chance: 0, yahtzee_bonus: 0, total: 0},
		 grand_total: {score: 0}
		}
	end

	def full_house_score
		25
	end

	def sm_straight_score
		30
	end

	def lg_straight_score
		40
	end

	def yahtzee_score
		50
	end

	# Small straight is when there's a sequence of 4 numbers. Eg: 1,2,3,4 or 2,3,4,5 or 3,4,5,6
	#
	# <b>Inputs</b>
	# * <b>dice_values</b> <em>Array</em> Array with value of all dices
	#
	def is_small_straight?(dice_values)
		((1..4).to_a - dice_values).empty? or ((2..5).to_a - dice_values).empty? or ((3..6).to_a - dice_values).empty?
	end

	# Large straight is when there's a sequence of 5 numbers. Eg: 1,2,3,4,3 or 2,3,4,5,6
	#
	# <b>Inputs</b>
	# * <b>dice_values</b> <em>Array</em> Array with value of all dices
	#
	def is_large_straight?(dice_values)
		((1..5).to_a - dice_values).empty? or ((2..6).to_a - dice_values).empty?
	end

	# Method to calculate total scores of each section and overall for each player at the end of each round
	#
	# <b>Inputs</b>
	# * <b>dice_values</b> <em>Array</em> Array with value of all dices
	#
	def round_total_scores(players)
		players.each do |player|
			player.player_total_scores
		end
	end

	# Analyze all possible scoring options
	#
	# <b>Inputs</b>
	# * <b>dice_values</b> <em>Hash</em> Hash with dice number and dice value as key and value respectively
	#
	def analyze_dice_scores(dice_scores)
		dice_values = dice_scores.values
		
		dice_sum = dice_values.inject(0){|sum, x| sum+x}

		cardinality_hash = {aces: dice_values.count(1), twos: dice_values.count(2), threes: dice_values.count(3),
							 fours: dice_values.count(4), fives: dice_values.count(5), sixes: dice_values.count(6)}
		value_cardinality = cardinality_hash.values
		bottom_score_evaluation = {three_of_a_kind: !([3,4,5] & value_cardinality).empty?, 
			four_of_a_kind: !([4,5] & value_cardinality).empty?,
		 	yahtzee: value_cardinality.include?(5), full_house: ([2,3] - value_cardinality).empty?,
		 	sm_straight: is_small_straight?(dice_values), lg_straight: is_large_straight?(dice_values)}

		derive_scores(dice_sum, cardinality_hash, bottom_score_evaluation)
	end

	# Derive scores and allot to appropriate scoring option
	#
	# <b>Inputs</b>
	# * <b>dice_sum</b> <em>Integer</em> Sum of values of all dices
	# * <b>cardinality_hash</b> <em>Hash</em> Hash with cardinality of each number
	# * <b>bottom_score_evaluation</b> <em>Hash</em> Evaluation helpers for bottom score options
	#	
	def derive_scores(dice_sum, cardinality_hash, bottom_score_evaluation)
		temp_score = score_template
		temp_score[:top][:aces] = cardinality_hash[:aces] * 1
		temp_score[:top][:twos] = cardinality_hash[:twos] * 2
		temp_score[:top][:threes] = cardinality_hash[:threes] * 3
		temp_score[:top][:fours] = cardinality_hash[:fours] * 4
		temp_score[:top][:fives] = cardinality_hash[:fives] * 5
		temp_score[:top][:sixes] = cardinality_hash[:sixes] * 6
		temp_score[:bottom][:three_of_a_kind] = bottom_score_evaluation[:three_of_a_kind] ? dice_sum : 0
		temp_score[:bottom][:four_of_a_kind] = bottom_score_evaluation[:four_of_a_kind] ? dice_sum : 0
		temp_score[:bottom][:full_house] =  bottom_score_evaluation[:full_house] ? full_house_score : 0
		temp_score[:bottom][:sm_straight] = bottom_score_evaluation[:sm_straight] ? sm_straight_score : 0
		temp_score[:bottom][:lg_straight] = bottom_score_evaluation[:lg_straight] ? lg_straight_score : 0
		temp_score[:bottom][:yahtzee] = bottom_score_evaluation[:yahtzee] ? yahtzee_score : 0
		temp_score[:bottom][:chance] = dice_sum

		temp_score
	end
	
end