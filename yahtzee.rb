require "./dice"
require "./player"
require "./score_helper"
require "./message_helper"

class Yahtzee
	include ScoreHelper
	include MessageHelper

	
	TOTAL_ROUNDS = 2
	MAX_TRIALS = 3
	CLEAR_COMMAND = (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM).nil? ? 'clear' : 'cls'
	attr_accessor :total_players, :players
	
	# Initialises the game object. Initialises players based on input for number of players
	#
	# <b>Inputs</b>
	# * <b>player_count</b> <em>Integer</em> Total number of players in the game
	#
	# <b>Output</b>
	# * Initialises given number of player objects and stores in players
	#
	def initialize(player_count)
		@total_players = player_count
		players = []
		player_count.times do |i|
			players << Player.new(i+1)
		end
		@players = players
	end

	# Rolloing the dices. It'll role given dice numbers or rolls all. Stores values in dice object
	#
	# <b>Inputs</b>
	# * <b>dice_obj</b> <em>Dice Object</em> Dice object. It has scores of 
	# * <b>player_obj</b> <em>player object</em> Current player's instance
	# * <b>dice_to_roll</b> <em>Array</em> Dice numbers to be rolled
	#
	# <b>Output</b>
	# * Rolls dice, display player's score and possible scoring option for the current trial 
	#
	def dice_trial(dice_obj, player_obj, dice_to_roll)
		puts "Rolling dice now:"
		dice_to_roll.each do |i|
			dice_value = roll_a_dice
			puts "Dice ##{i} value: #{dice_value}"
			dice_obj.scores["dice_#{i}".to_sym] = dice_value
		end
		puts "Score summary of all dices ==> #{pretty_print_hash(dice_obj.scores)}"
		# Possible score options
		puts "\n\n"
		player_obj.calculate_and_display_score_options(dice_obj.scores)
		puts "Overall score for player #{player_obj.id}:"

		score_display(player_obj.score)
		puts "="*20
		puts "Following are possible scores to choose from:"
		score_display(player_obj.round_scores, true)
	end

	# Rolls one dice to give a number
	def roll_a_dice
		rand(1..6)
	end

	# Game starter
	def self.start_game
		puts "Please the the total number of players"
		total_players = take_user_input("counter")

		new_yahtzee_game = Yahtzee.new(total_players)

		puts "Total players = #{new_yahtzee_game.total_players}"
		puts "Starting the game ====================================================================>"
		TOTAL_ROUNDS.times do |round|
			round_num = round + 1
			puts "*"*15 +  "  ROUND #{round_num}  " + "*"*15
			new_yahtzee_game.total_players.times do |player_number|
				player_num = player_number + 1
				puts "*"*15 +  "  PLAYER NUMBER #{player_num}  " + "*"*15
				puts "Press Enter to start this round"
				gets
				dice = Dice.new
				current_player = new_yahtzee_game.players[player_number]
				current_player.round_scores = new_yahtzee_game.score_template
				dice_to_roll = Dice::DEFAULT_DICE_TO_ROLL
				MAX_TRIALS.times do |trial_number|
					trial_num = trial_number + 1
					should_break = false
					new_yahtzee_game.clear_screen
					puts "Round: #{round_num}, Player: #{player_num}, Trial: #{trial_num}\n\n"
					new_yahtzee_game.dice_trial(dice, current_player, dice_to_roll)
					
					# Update score count based on user input for the current player 
					
					if MAX_TRIALS == trial_num
						new_yahtzee_game.finish_round(current_player)
						puts "Done for player #{player_num} for this round #{round_num}\n\n\n"
					else
						puts "Do you want to roll again? Say (y/n)"
						retain_dice = take_user_input("yes_no")
						if retain_dice.downcase == "y"
							current_player.round_scores = new_yahtzee_game.score_template
							puts "Which dice do you want to retain? Please speicy comma separated dice numbers. Eg: 1,3,5. If none specified all dice will be rolled"
							retained_dice = take_user_input("dice_retainment")
							dice_to_roll = (1..5).to_a - retained_dice
							puts "Rolling these dice now: #{dice_to_roll}" 
						else
							new_yahtzee_game.finish_round(current_player)
							puts "Done for player #{player_num} for this round #{round_num}\n\n\n"
							should_break = true
						end
					end
					break if should_break
				end
				current_player.player_total_scores
			end
		end
		new_yahtzee_game.display_final_scores(new_yahtzee_game.players)
	end

	# A reurring Method to finish a round for a player
	# This aims to take an input from player for score to use, validate and update player's scoresheet accordingly
	#
	# <b>Inputs</b>
	# * <b>player</b> <em>player object</em> Current player's instance
	# * <b>show_error_message</b> <em>Boolean</em> True when this method figures out an error  and calls itself
	#
	# <b>Output</b>
	# * Rolls dice, display player's score and possible scoring option for the current trial 
	# * If given option is not valid, it calls itself asking for a valid scoring option
	#
	def finish_round(player, show_error_message = false)
		error_message = show_error_message ? "Option you chose is invalid. " : ""
		puts error_message + "Please choose a possile section and score in 'section, score' format. Eg: top, aces"
		section_chosen, score_type_chosen = gets.chomp.gsub(" ", "").split(",")
		if player.is_valid_scoring_option?(section_chosen, score_type_chosen)
			player.update_score(section_chosen, score_type_chosen)
			puts "Your scores are::::"
			score_display(player.score)
		else
			finish_round(player, true)
		end
	end

	# Method to clear screen 
	def clear_screen
		puts "Clearing screen"
		system(CLEAR_COMMAND)
	end

	# A method to consolidate all different types of inputs, validate and return suitable, valid output
	#
	# <b>Inputs</b>
	# * <b>input_type</b> <em>String</em> Input type to validate the intput accordingly
	#
	# <b>Output</b>
	# * If input valid, give the valid input
	# *  else, call the same method again
	#
	def self.take_user_input(input_type)
		input = gets.chomp
		case input_type
		when "yes_no"
			yes_no_input_validation(input, input_type)
		when "counter"
			counter_input(input, input_type)
		when "dice_retainment"
			dice_retainment_input(input, input_type)
		else 
			false
		end
	end

	# Method to validate a Yes or No kind of input
	#
	# <b>Inputs</b>
	# * <b>input</b> <em>String</em> user input. 
	# * <b>input_type</b> <em>String</em> Input type to validate the intput accordingly
	#
	# <b>Output</b>
	# * If input valid, give the valid input
	# *  else, call the same method again
	#
	def self.yes_no_input_validation(input, input_type)
		input = input.downcase
		acceptable_values = ["y", "n"]
		if acceptable_values.include?(input)
			input
		else
			puts "Invalid input. Please provide one from #{acceptable_values.inspect}"
			take_user_input(input_type)
		end
	end

	# Method to validate counter kind of input
	#
	# <b>Inputs</b>
	# * <b>input</b> <em>Integer</em> user input for counter. 
	# * <b>input_type</b> <em>String</em> Input type to validate the intput accordingly
	#
	# <b>Output</b>
	# * If input valid, give the valid input
	# *  else, call the same method again
	#
	def self.counter_input(input, input_type)
		input = input.to_i
		if input > 0
			input
		else
			puts "Invalid input. Please provide a number greater than 0"
			take_user_input(input_type)
		end
	end

	# Method to validate input for dice retainment. It expects a number from 1 to 5
	#
	# <b>Inputs</b>
	# * <b>input</b> <em>String of comma separated numbers</em> Dice numbers to retain(not roll)
	# * <b>input_type</b> <em>String</em> Input type to validate the intput accordingly
	#
	# <b>Output</b>
	# * If input valid, give the valid input
	# *  else, call the same method again
	#
	def self.dice_retainment_input(retained_dice, input_type)
		retain_dice_array = retained_dice.gsub(" ", "").split(",").map{|ele| ele.to_i}
	
		puts "Dices retained are #{retain_dice_array.inspect}"
		if retain_dice_array.empty? or (retain_dice_array - (1..5).to_a).empty?
			retain_dice_array
		else
			puts "Please provide dice numbers one of 1 to 5, comma separated"
			take_user_input(input_type)
		end
			
	end

	
end


