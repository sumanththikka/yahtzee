class Dice
	DEFAULT_DICE_TO_ROLL = [1,2,3,4,5]
	attr_accessor :scores
	def initialize
		# TODO :: remove dice_ from keys
		@scores = {dice_1: 0, dice_2: 0, dice_3: 0, dice_4: 0 , dice_5: 0}
	end
end