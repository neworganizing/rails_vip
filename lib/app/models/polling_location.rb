class PollingLocation < ActiveRecord::Base
	belongs_to :source

	has_and_belongs_to_many :precincts
	has_and_belongs_to_many :precinct_splits
	has_many :custom_notes, :as => :object

#	has_many :ballot_dropoff_locations

#	def custom_notes
#		CustomNotes.find(:all, :conditions => ["source_id = ? AND object_id = ?", 
#		                                        self.source_id, self.file_internal_id])
#	end
end
