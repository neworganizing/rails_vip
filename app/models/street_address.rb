class StreetAddress < ActiveRecord::Base
	has_many :start_street_segments, :class_name => 'StreetSegment', :foreign_key => 'start_street_address_id'
	has_many :end_street_segments, :class_name => 'StreetSegment', :foreign_key => 'end_street_address_id'
	belongs_to :source
	belongs_to :state
	def street_segments
		start_street_segments + end_street_segments
	end
end
