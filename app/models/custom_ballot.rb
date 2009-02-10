class CustomBallot < ActiveRecord::Base
	belongs_to :source
	belongs_to :ballot
	has_many   :ballot_responses
end
