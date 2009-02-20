class StreetSegment < ActiveRecord::Base
	belongs_to :start_street_address, :class_name => 'StreetAddress'
	belongs_to :end_street_address, :class_name => 'StreetAddress'
	belongs_to :precinct
	belongs_to :precinct_split

	belongs_to :source
	has_many :custom_notes, :as => :object

	def find_by_address(address, include_inactive = false)

		street_num   = address[:street_num]
		street_name  = address[:street].upcase
		state        = address[:state].upcase
		city         = address[:city].upcase

		even_odd = (street_num.to_i % 2 == 0) ? 'even' : 'odd'
	
		if (!include_inactive)
			active_sources = Source.find(:all, :conditions => "active = 1")
			active_conditions = "(street_segments.source_id IN (" + active_sources.collect(&:id).join(',') + "))"
		else
			active_conditions = "(1=1)"
		end

		StreetSegment.first(:joins => "INNER JOIN street_addresses start ON street_segments.start_street_address_id=start.id
		                               INNER JOIN street_addresses end   ON street_segments.end_street_address_id=end.id
		                               INNER JOIN states s               ON start.state_id=s.id",
		                    :conditions => ["UPPER(start.std_street_name) = ? AND UPPER(end.std_street_name) = ? AND

						     ((start.std_house_number <= ? AND end.std_house_number >= ?) 
		                                      OR (start.std_house_number IS NULL AND end.std_house_number IS NULL)) AND 
		                                     
		                                     street_segments.odd_even_both IN (?, 'both') AND 
			                             start.city = ? AND end.city = ? AND
		                                     s.name = ? AND
		                                     #{active_conditions}", 
			                             street_name, street_name, 
		                                     street_num, street_num, 
			                             even_odd, city, city, state]
		)
		
		                                   
	end
end
