class Candidate < ActiveRecord::Base
	belongs_to :source
	has_many :candidate_statements
	has_many :candidate_ballots
	has_many :ballots, :through => :candidate_ballots
	
end
