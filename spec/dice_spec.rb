require 'spec_helper'

describe Dice do
  before :each do
    @dice = Dice.new()
  end
  it 'should test if dice object is an instance of Dice' do
    expect(@dice).to be_an_instance_of Dice
  end

  it 'should test if dice object has scores hash' do
  	expect(@dice.scores).to eql({dice_1: 0, dice_2: 0, dice_3: 0, dice_4: 0 , dice_5: 0})
  end

  it 'should have 5 elements' do 
  	expect(@dice.scores.length).to eq(5)
  end

end