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

	# Defaults mail_only to 'no' if ward is nil, per spec
	def before_save
		if (self.ward.nil? && self.mail_only.nil?) then
			self.mail_only = "no"
		end
	end

	# Uses StreetSegment.find_by_address to return a street segment based on an address
	def find_by_address(address)
		ss = StreetSegment.find_by_address(address)
		ss.nil? ? nil : ss.precinct
	end

	# return all contests that apply to this precinct
	def contests
		all_tabs = [tabulation_areas.collect{|t| t.parents} + tabulation_areas].flatten
		all_tabs.collect{|t| t.contests}.flatten.uniq
	end

	# return all ballot drop locations, or, if none present, other ballot drop locations in same locality.
	alias_method :ballot_drop_locations, :ballot_drop_locations_builtin
	def ballot_drop_locations
		#bdls = BallotDropLocation.find(:all, 
		#                                :joins => "INNER JOIN ballot_drop_locations_precincts 
		#                                            ON ballot_drop_locations_precincts.ballot_drop_location_id = ballot_drop_locations.id",
		#                                :conditions => ["ballot_drop_locations_precincts.precinct_id = ?",self.id])
		bdls = ballot_drop_locations_builtin
		if (bdls.size == 0)
			bdls = BallotDropLocation.find(:all, :conditions => {:source_id => self.source_id, :locality_id => self.locality_id})
		end

		bdls
	end
end
