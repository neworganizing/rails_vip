class PollingLocationController < ApplicationController

	def show
		require 'rubygems'
		require 'google_geocode'
		@title = "Polling Location"
		@polling_location = PollingLocation.find(params[:id])
		gg = GoogleGeocode.new "ABQIAAAAu7Re6QJVDQ3U5Sp2u2w3UhSwMyR9mQOTO__cwzDlnGLWnDHQaxQofqAx35lKdPCM1ODtbttHZKOR3Q"	

		address_versions = []
		address_versions.push @polling_location.address

		sample_location = @polling_location.precincts.first
		sample_location = @polling_location.precinct_splits.first if sample_location.nil?
		if sample_location and sample_location.street_segments.size > 0
			address_versions.push @polling_location.name    + ', ' + \
			                      @polling_location.address + ', ' + \
			                      sample_location.street_segments.first.start_street_address.city + ', ' + \
			                      sample_location.locality.state.name 

			address_versions.push @polling_location.name    + ', ' + \
			                      @polling_location.address + ', ' + \
			                      sample_location.street_segments.first.start_street_address.city + ', ' + \
			                      sample_location.locality.state.name 

			address_versions.push @polling_location.address + ', ' + \
			                      sample_location.street_segments.first.start_street_address.city + ', ' + \
			                      sample_location.locality.state.name 
		end	
		@polling_loc_std = nil

		address_versions.each do |addr|
			if @polling_loc_std.nil? then
				begin
					@polling_loc_std = gg.locate addr
				rescue
					@polling_loc_std = nil
				end
			end #polling_loc_std.nil
		end #each address

		if (!@polling_loc_std.nil?) then
			puts "got polling_loc_std"
			
			pollurl = 'http://www.martintod.org.uk/blog/LDballotBox.png'
			@map = GMap.new('map_div')
			@map.icon_global_init(GIcon.new(
				:copy_base => GIcon::DEFAULT,
				:image => pollurl,
				:icon_size => GSize.new(20,34)),
#				:icon_anchor => GPoint.new(7,7),
#				:info_window_anchor => GPoint.new(9,2)),
				"icon_poll")
			icon_poll = Variable.new("icon_poll")
			@map.overlay_init(GMarker.new(@polling_loc_std.coordinates,
			                    :title => @polling_location.name,
			                    :info_window => @polling_location.name, 
			                    :icon => icon_poll
				    ))
			@map.control_init(:large_map => true, :map_type => true)
			@map.center_zoom_init(@polling_loc_std.coordinates,15)
		end
	end

	def index
		if (params["source"])
			@source = Source.find(params["source"])
			@polling_locations = @source.polling_locations
		elsif (params["locality"])
			@locality = Locality.find(params["locality"])
			@polling_locations = @locality.precincts.map(&:polling_locations)
		elsif (params["precinct"])
			@precinct = Locality.find(params["precinct"])
			@polling_locations = @precinct.polling_locations
		else
			@polling_locations = PollingLocation.find(:all)
		end
	end
end
