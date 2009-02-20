class BallotDropLocation < ActiveRecord::Base
	belongs_to :source
	has_and_belongs_to_many :precincts
	has_many :precinct_splits
	belongs_to :locality
	belongs_to :state
	has_many :custom_notes, :as => :object
end
