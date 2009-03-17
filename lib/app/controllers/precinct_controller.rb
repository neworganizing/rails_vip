class PrecinctController < ApplicationController
	POLL_URL = 'http://www.martintod.org.uk/blog/LDballotBox.png'
	HOME_URL = 'http://maps.google.com/mapfiles/kml/shapes/homegardenbusiness.png'
	STATES = [
		[ "AL", "Alabama" ],
		  [ "AK", "Alaska" ],
		  [ "AZ", "Arizona" ],
		  [ "AR", "Arkansas" ],
		  [ "CA", "California" ],
		  [ "CO", "Colorado" ],
		  [ "CT", "Connecticut" ],
		  [ "DE", "Delaware" ],
		  [ "FL", "Florida" ],
		  [ "GA", "Georgia" ],
		  [ "HI", "Hawaii" ],
		  [ "ID", "Idaho" ],
		  [ "IL", "Illinois" ],
		  [ "IN", "Indiana" ],
		  [ "IA", "Iowa" ],
		  [ "KS", "Kansas" ],
		  [ "KY", "Kentucky" ],
		  [ "LA", "Louisiana" ],
		  [ "ME", "Maine" ],
		  [ "MD", "Maryland" ],
		  [ "MA", "Massachusetts" ],
		  [ "MI", "Michigan" ],
		  [ "MN", "Minnesota" ],
		  [ "MS", "Mississippi" ],
		  [ "MO", "Missouri" ],
		  [ "MT", "Montana" ],
		  [ "NE", "Nebraska" ],
		  [ "NV", "Nevada" ],
		  [ "NH", "New Hampshire" ],
		  [ "NJ", "New Jersey" ],
		  [ "NM", "New Mexico" ],
		  [ "NY", "New York" ],
		  [ "NC", "North Carolina" ],
		  [ "ND", "North Dakota" ],
		  [ "OH", "Ohio" ],
		  [ "OK", "Oklahoma" ],
		  [ "OR", "Oregon" ],
		  [ "PA", "Pennsylvania" ],
		  [ "RI", "Rhode Island" ],
		  [ "SC", "South Carolina" ],
		  [ "SD", "South Dakota" ],
		  [ "TN", "Tennessee" ],
		  [ "TX", "Texas" ],
		  [ "UT", "Utah" ],
		  [ "VT", "Vermont" ],
		  [ "VA", "Virginia" ],
		  [ "WA", "Washington" ],
		  [ "WV", "West Virginia" ],
		  [ "WI", "Wisconsin" ],
		  [ "WY", "Wyoming" ]
  		]

	require 'rubygems'
	require 'google_geocode'

	def show
		@precinct = Precinct.find(params[:id])
		@polling_locations = @precinct.polling_locations
	end

	def lookup
		#set defaults
		@params ||= params
		@params[:street_num] ||= ''
		@params[:street]     ||= ''
		@params[:city]       ||= ''
		@params[:state]      ||= ''
		@STATES = [['','']]+STATES

		if request.post?
#			puts "got request"

#			data = params[:form_data]
			data = Hash.new
			data[:street_num] = params[:street_num]
			data[:street] = params[:street]
			data[:city] = params[:city]
			data[:state] = params[:state]
			input_address = data[:street_num] + " " +
			                data[:street] + ", " +
			                data[:city] + ", " +
			                data[:state]
			#standardize address
			
			#still just a string, but at least it looks good 
			@ss = StreetSegment.new.find_by_address(data)
			if (!@ss.nil?) then
				#puts "got ss"
				@split    = @ss.precinct_split
				@precinct = @split.nil? ? @ss.precinct : @split.precinct 
				@contests = @split.nil? ? @precinct.contests : @split.contests
				@polling_location = @precinct.polling_locations.first
				@ev_locs = @precinct.ballot_drop_locations
			
				@polling_loc_std = nil
			end #!ss.nil?
		end
	end

	def index
		
		if (params["source"])
			@source = Source.find(params["source"])
			@precincts = @source.precincts
		elsif (params["locality"])
			@locality = Locality.find(params["locality"])
			@precincts = @locality.precincts
		elsif (params["ballot_drop_location"])
			@ballot_drop_location = BallotDropLocation.find(params["ballot_drop_location"])
			@precincts = @ballot_drop_location.precincts
		else
			@precincts = Precinct.find(:all)
		end
	end
end
