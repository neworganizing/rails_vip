class PrecinctSplit < ActiveRecord::Base
	belongs_to :source
	belongs_to :precinct

	has_and_belongs_to_many :polling_locations
	has_and_belongs_to_many :tabulation_areas

	has_many :custom_notes, :as => :object

	# Uses StreetSegment.find_by_address to return a street segment based on an address
	def find_by_address(address)
		ss = StreetSegment.new.find_by_address(address)
		ss.nil? ? nil : ss.precinct_split
	end

	# return all contests that apply to this precinct
	def contests
		all_tabs = [tabulation_areas.collect{|t| t.parents} + tabulation_areas].flatten
		[all_tabs.collect{|t| t.contests} + precinct.contests].flatten.uniq
	end
end

