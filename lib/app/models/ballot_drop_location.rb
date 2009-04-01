class BallotDropLocation < ActiveRecord::Base
	belongs_to :source
	has_and_belongs_to_many :precincts
	has_many :precinct_splits
	belongs_to :locality
	belongs_to :state
	has_many :custom_notes, :as => :object
	
	alias_method :precincts_builtin, :precincts
	# this finds both the precincts that explicitly use this ballot drop location and
	# the precincts that use it implicitly, because they are in the same locality and 
	# do not specify a ballot drop location
	def precincts
		precs = precincts_builtin + Precinct.find(:all, 
		                                          :joins => "LEFT JOIN ballot_drop_locations_precincts jointable
		                                                            ON jointable.precinct_id = precincts.id",
		                                          :conditions => ["jointable.ballot_drop_location_id IS NULL AND
		                                                          precincts.locality_id = ?", self.locality_id])
	end
end
