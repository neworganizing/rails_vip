class CustomBallot < ActiveRecord::Base
	belongs_to :source
	belongs_to :ballot
	has_and_belongs_to_many   :ballot_responses
end
