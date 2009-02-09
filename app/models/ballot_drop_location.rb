class BallotDropLocation < ActiveRecord::Base
	belongs_to :source
	has_many :precincts
	has_many :precinct_splits
	belongs_to :locality
	belongs_to :state
end
