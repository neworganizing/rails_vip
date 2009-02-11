class Precinct < ActiveRecord::Base
	belongs_to :source
	belongs_to :locality

	has_and_belongs_to_many :polling_locations
	has_and_belongs_to_many :tabulation_areas
	has_and_belongs_to_many :ballot_drop_locations

	has_many :precinct_splits
	has_many :street_segments

	#TODO: ballot_drop_locations table

	validates_presence_of :source, 
		:file_internal_id,
		:locality_id

	def before_save
		if (self.ward.nil? && self.mail_only.nil?) then
			self.mail_only = "no"
		end
	end

	def find_by_address(address)
		ss = StreetSegment.new.find_by_address(address)
		ss.nil? ? nil : ss.precinct
	end



end
