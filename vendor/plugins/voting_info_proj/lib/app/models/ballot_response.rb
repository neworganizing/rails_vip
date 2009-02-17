class BallotResponse < ActiveRecord::Base
	belongs_to :source
	has_and_belongs_to_many :referendums
	has_and_belongs_to_many :custom_ballots
end
