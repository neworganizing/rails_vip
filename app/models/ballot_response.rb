class BallotResponse < ActiveRecord::Base
	belongs_to :source
	belongs_to :custom_ballot
	has_and_belongs_to_many :referendums
end
