require "spec_helper"

describe Player do
  before :each do
    @player = Player.new(1)
    @player.round_scores = @player.score_template
  end
  it "test player object" do
    expect(@player).to be_an_instance_of Player
  end

  describe "update_score should" do
	  it "update the scores in score attribute from round_scores" do
	  	@player.round_scores[:top][:aces] = 10
	  	@player.round_scores[:top][:twos] = 20
	  	@player.update_score(:top, :aces)
	  	expect(@player.score[:top][:aces]).to eq(@player.round_scores[:top][:aces])
	  end
	end

	describe "is_valid_scoring_option should " do
	  describe "return false if invalid section passed: " do
	  	it "subcase: return false if section is nil" do 
	  		expect(@player.is_valid_scoring_option?(nil, :aces)).to be false
	  	end

	  	it "subcase: return false if section is not one of acceptable values" do 
	  		expect(@player.is_valid_scoring_option?(:topped, :aces)).to be false
	  	end
	  end

	  describe "return false if invalid score_type passed: " do
	  	it "subcase: return false if score_type is nil" do 
	  		expect(@player.is_valid_scoring_option?(:top, nil)).to be false
	  	end

	  	it "subcase: return false if score_type is not one of acceptable values" do 
	  		expect(@player.is_valid_scoring_option?(:top, :acessss)).to be false
	  	end
	  end

	  it "return false if section, score_type combination is invalid" do
	  	expect(@player.is_valid_scoring_option?(:bottom, :aces)).to be false
	  end

	  it "return false if given score is 0 in probable score options" do
	  	@player.round_scores[:top][:aces] = 2
	  	expect(@player.is_valid_scoring_option?(:top, :twos)).to be false
	  end

	  it "return true if section, score_types are proper and their corresponding score is > 0" do 
	  	@player.round_scores[:top][:aces] = 2
	  	expect(@player.is_valid_scoring_option?(:top, :aces)).to be true
		end
	end

	describe "player_total_scores should properly update the totals in sections and grand total: " do 
		before :each do
			@player_2 = Player.new(2)
			@player_2.score[:top][:aces] = 2
			@player_2.score[:top][:twos] = 4
			@player_2.score[:top][:threes] = 9
			@player_2.score[:bottom][:three_of_a_kind] = 12
			@player_2.score[:bottom][:four_of_a_kind] = 10
			@player_2.player_total_scores
		end
		
		it "top scores should sum up to its total" do
			expect(@player_2.score[:top][:total]).to eq(@player_2.score[:top][:aces] + @player_2.score[:top][:twos] + @player_2.score[:top][:threes])
		end

		it "bottom scores should sum up to its total" do
			expect(@player_2.score[:bottom][:total]).to eq(@player_2.score[:bottom][:three_of_a_kind] + @player_2.score[:bottom][:four_of_a_kind])
		end

		it "individual totals scores should sum up to its grand_total" do
			expect(@player_2.score[:grand_total][:score]).to eq(@player_2.score[:top][:total] + @player_2.score[:bottom][:total])
		end
	end


end