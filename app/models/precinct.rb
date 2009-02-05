class Precinct < ActiveRecord::Base
	belongs_to :source
	belongs_to :locality

	belongs_to :polling_location

	validates_presence_of :source, 
		:file_internal_id,
		:locality_id

	def find_by_address(address)
		ss = StreetSegment.new.find_by_address(address)
		ss.precinct
	end

end
