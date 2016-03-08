require "./score_helper"
class Player
	include ScoreHelper

	attr_accessor :id, :score, :round_scores

	# Initialises the player object. Assigns player id, scoresheet
	#
	# <b>Inputs</b>
	# * <b>player_number</b> <em>Integer</em> Player number
	#
	# <b>Output</b>
	# * player object initialised
	#
	def initialize(player_number)
		@id = player_number
		@score = score_template
	end

	# Method to analyze values of all dice rolled and display possible scoring options to the player 
	#
	# <b>Inputs</b>
	# * <b>dice_scores</b> <em>Score object</em>  scoresheet of a player
	#
	def calculate_and_display_score_options(dice_scores)
		puts "Temp score board"
		possible_scores = analyze_dice_scores(dice_scores)
		derive_scoring_options(possible_scores)
	end

	# Method to analyze values of all dice rolled and derive based on player's scoresheet
	#
	# <b>Inputs</b>
	# * <b>possible_scores</b> <em>Score object</em>  Score sheet with possible values based on current dice roll
	#
	def derive_scoring_options(possible_scores)
		possible_scores.each do |section, section_scores|
			section_scores.each do |score_type, particular_score|
				round_scores[section][score_type] = score[section][score_type] > 0 ? 0 : particular_score
			end
		end
	end

	# Update a players score based on player's input
	#
	# <b>Inputs</b>
	# * <b>section</b> <em>String</em>  section identifier. Eg: Top, bottom, grand_total
	# * <b>score_type</b> <em>Score object</em>  Score sheet with possible values based on current dice roll
	#
	def update_score(section, score_type)
		score_chosen_now = round_scores[section.to_sym][score_type.to_sym]
		score[section.to_sym][score_type.to_sym] = score_chosen_now
		score[section.to_sym][:total] += score_chosen_now
		score[:grand_total][:score] += score_chosen_now
	end

	# Determines if given scoring option is possible or not
	#
	# <b>Inputs</b>
	# * <b>section</b> <em>String</em>  section identifier. Eg: Top, bottom, grand_total
	# * <b>score_type</b> <em>Score object</em>  Score sheet with possible values based on current dice roll
	#
	def is_valid_scoring_option?(section, score_type)
		return false if section.nil? or score_type.nil?
		return true if !round_scores[section.to_sym].nil? and !round_scores[section.to_sym][score_type.to_sym].nil? and round_scores[section.to_sym][score_type.to_sym] != 0
		return false
	end

	# Calculte players scores at the end of each round for player
	#
	def player_total_scores
		top_total = score[:top].values.inject(0){|sum, x| sum+x} - score[:top][:total]
		bottom_total = score[:bottom].values.inject(0){|sum, x| sum+x} - score[:bottom][:total]
		score[:top][:total] = top_total
		score[:bottom][:total] = bottom_total
		score[:grand_total][:score] = top_total + bottom_total
	end

end