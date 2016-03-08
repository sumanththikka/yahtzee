module MessageHelper
	
	# Method to display score for a player
	#
	# <b>Inputs</b>
	# * <b>score</b> <em>Score Obj</em> Score object
	# * <b>skip_zeroes</b> <em>boolean</em> If true(for possible scores display),  don't display score keys which are not applicable
	#
	# <b>Output</b>
	# * Displays scores
	#
	def score_display(score, skip_zeroes=false)
		display_string = ""
		score.each do |section, scores|
			display_string += "\t" + section.to_s + ": {"
			scores.each do |score_type, score|
				next if score == 0 and skip_zeroes
				display_string +=  "#{score_type}: #{score}, "
			end
			display_string += "}\n"
		end
		puts "#{display_string}\n\n"
	end

	def pretty_print_hash(hash_obj)
		display_string_values = []
		hash_obj.each do |key, value|
			display_string_values << "#{key}: #{value}"
		end
		display_string_values.join(", ")
	end

	# Method to display final scores of all players and the winner of the game
	#
	# <b>Inputs</b>
	# * <b>players</b> <em>Array</em> All objects of players in an array with their final scores update in score
	#
	# <b>Output</b>
	# * Displays scores
	#
	def display_final_scores(players)
		all_scores = []
		puts "\n\n"
		puts "*"*20
		puts "FINAL SCORES"
		players.each do |player|
			player_score = player.score[:grand_total][:score]
			puts "\tPlayer#{player.id}: #{player_score}"
			all_scores << player_score
		end
		max_score = all_scores.max
		if all_scores.count(max_score) > 1
			puts "Its a tie!! Play again to find out clear winner!!"
		else
			puts "Player #{all_scores.index(max_score) + 1} wins!!!! Yay!! Congratulations!!"
		end
		
		puts "*"*20

	end
end