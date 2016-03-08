require 'spec_helper'

describe Yahtzee do

	describe "counter_input method should take only positive integers" do 
		it "should return the input if its postive" do
			input = 1
			expect(Yahtzee.counter_input(input, "")).to eq(input)
		end
		it "input_type doesn't matter when input is valid" do
			input = 1
			input_type = "blah blah"
			expect(Yahtzee.counter_input(input, input_type)).to eq(input)
		end
	end

	describe "dice_retainment_input method should take string with only comma separated positive integers from 1 to 5" do 
		it "should return array of integers given in string" do
			input = "1,2,3"
			expect(Yahtzee.dice_retainment_input(input, "")).to eql([1,2,3])
		end
		it "should return array of integers given in string" do
			input = "1,2,3"
			input_type = "blah blah"
			expect(Yahtzee.dice_retainment_input(input, input_type = "blah blah")).to eql([1,2,3])
		end
		it "should accept empty string as well" do
			input = ""
			expect(Yahtzee.dice_retainment_input(input, "")).to eql([])
		end
		it "should accept empty string as well" do
			input = ""
			input_type = "blah blah"
			expect(Yahtzee.dice_retainment_input(input, input_type = "blah blah")).to eql([])
		end
	end


	describe "yes_no_input_validation method should take only 'y' or 'n'" do 
		it "should return the input if its 'y' or 'n'" do
			input = 'y'
			input_type = "blah blah"
			expect(Yahtzee.yes_no_input_validation(input, "")).to eq(input)
			expect(Yahtzee.yes_no_input_validation(input, input_type)).to eq(input)
			input = 'n'
			expect(Yahtzee.yes_no_input_validation(input, "")).to eq(input)
			expect(Yahtzee.yes_no_input_validation(input, input_type)).to eq(input)
		end
	end

end