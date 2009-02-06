class Precinct < ActiveRecord::Base
	belongs_to :source
	belongs_to :locality

	belongs_to :polling_location
	has_many :precinct_splits
	has_many :street_segments

	validates_presence_of :source, 
		:file_internal_id,
		:locality_id

	def find_by_address(address)
		ss = StreetSegment.new.find_by_address(address)
		ss.nil? ? nil : ss.precinct
	end

end
