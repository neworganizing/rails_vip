class BallotDropLocation < ActiveRecord::Base
	belongs_to :source
	belongs_to :precinct
end
