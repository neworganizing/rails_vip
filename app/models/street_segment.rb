class StreetSegment < ActiveRecord::Base
	belongs_to :start_street_address, :class_name => 'StreetAddress'
	belongs_to :end_street_address, :class_name => 'StreetAddress'
	belongs_to :precinct
	belongs_to :precinct_split

	belongs_to :source

	FULL_STATE_NAMES = {'KS' => 'Kansas'}

	def find_by_address(address)


		street_num   = address[:street_num]
		street_name  = address[:street].upcase
		state_abbrev = address[:state].upcase
		state_full   = FULL_STATE_NAMES[state_abbrev]
		state        = address[:state].upcase
		city         = address[:city].upcase

		even_odd = (street_num % 2 == 0) ? 'even' : 'odd'

		
		StreetSegment.first(:joins => "INNER JOIN street_addresses start ON street_segments.start_street_address_id=start.id
		                               INNER JOIN street_addresses end   ON street_segments.end_street_address_id=end.id
		                               INNER JOIN states s               ON start.state_id=s.id",
		                    :conditions => ["start.house_number <= ? AND end.house_number >= ? AND 
		                                     UPPER(start.street_name) = ? AND UPPER(end.street_name) = ? AND 
		                                     street_segments.odd_even_both IN (?, 'both') AND 
			                             start.city = ? AND
		                                     s.name IN (?, ?)", street_num, street_num, street_name, street_name, even_odd, city, state_abbrev, state_full]
		)
		
		                                   
	end
end
