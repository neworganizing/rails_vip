class VipHandler 
	# Parses Voting Information Project format version 1.4
	
	require 'rubygems'
	require 'ruby-prof'	
	require 'libxml'

	include LibXML::XML::SaxParser::Callbacks

	Debug = 0   #debug level

	
	# defines which top-level elements to parse
	Topelements = ["source","state",
	               "locality","precinct", "election",
	               "precinct_split", "election_administration",       #
	               "election_official", "ballot_drop_location",       #
	               "contest","candidate","campaign_issue",   #
	               "campaign_statement","custom_ballot",     #
	               "custom_note","referendum",               #
	               "polling_location","street_segment",
	               "street_address", "ballot","ballot_response",
	               "tabulation_area"]

	# don't try to map the following ID elements to objects
	IdExceptions = ["vip_id", "file_internal_id"]


	# Takes attrib as the element from xml with val as it's value.
	# Assumes that element name is the class attribute name, except in 
	# the case of id's. 
	# * Maps element's ID to file_internal_id
	# * Overwrites IDs referenced by elements to database internal IDs

	def addXmlAttribute(obj, attrib, val)
		if (attrib.eql?("id"))
			puts attrib if Debug > 4
			innerattrib = "file_internal_id"
		else
			innerattrib = attrib
		end

		# store object if it exists
		if obj.respond_to?(innerattrib) or 
		   obj.respond_to?(innerattrib[0,innerattrib.size-3].pluralize) then

			if (innerattrib[-3,3] == '_id' && !IdExceptions.include?(innerattrib))
				#this is an ID in the file we need to map
				#to the database's internal ID

				#grab attribute type from innerattrib (drop _id)
				attribute_type = innerattrib[0,innerattrib.size-3]
				puts attribute_type if Debug > 3

				#drop start_ or end_ from attribute type of street address id's
#				if (attribute_type.length >= 14 && attribute_type[-14,14] == 'street_address') then
#					attribute_type = 'street_address'
#				end
#				referenced_obj = attribute_type.camelcase.constantize.find(:first, 
#				                    :conditions => "source_id = #{@source_id} AND file_internal_id = #{val}")
			
				attr_reflection =   obj.class.reflect_on_association(attribute_type.to_sym)	
				attr_reflection ||= obj.class.reflect_on_association(attribute_type.pluralize.to_sym)	

				attribute_class = attr_reflection.klass 
				referenced_obj = @source_id.nil? ? nil : attribute_class.find(:first, 
				                    :conditions => ["source_id = ? AND file_internal_id = ?", 
				                                    @source_id, val ])

				if referenced_obj.nil? then
					# we haven't found the referenced ID in the stack yet.
					# Add it to a table storing unresolved objects
					badone = UnresolvedId.new do |u|
						u.source       = @source
						u.object_class = obj.class.name
						u.parameter    = attrib
						u.val          = val
					end

					# save it to a stack.  We'll store it when the object gets an ID
					@unresolved_ids.push(badone)

					puts 'Added '+innerattrib+' to resolution list.  Fail #'+@unresolved.to_s if Debug > 3

					# save file_internal_id in place of object id, unless it's HABTM
					obj.[]=(innerattrib,val) if obj.has_attribute?(innerattrib)

					return false

				else #referenced object is not nil
					# store object id
					if obj.has_attribute?(innerattrib)
						puts "Adding singular object " + innerattrib if Debug > 4
						#not HABTM
						obj.[]=(innerattrib,referenced_obj.id)
					else
						puts "Adding plural object " + innerattrib if Debug > 4
						#HABTM
		   				plural_attrib = innerattrib[0,innerattrib.size-3].pluralize
						puts plural_attrib if Debug > 4
#						puts referenced_obj.inspect if Debug > 4
						
						puts eval('obj.'+plural_attrib).inspect if Debug > 4
						
						eval('obj.'+plural_attrib).push referenced_obj
					end

					puts 'Set '+innerattrib+' to valid object.  Success #'+@resolved.to_s if Debug > 3
					return true

				end #if referenced_obj.nil?
					
#			elsif (innerattrib.eql?('file_internal_id')) then
#				#make sure we store a string and not an object
#				obj.[]=(innerattrib,val.to_i)
#				puts 'Set '+innerattrib+' to '+val.to_s if Debug > 3

			else #just a normal attribute, not an object reference

				#don't store unnecessary white space
				val.strip!

				#TODO: Make DRY.  Actually, why would there be a HABTM here?
				if obj.has_attribute?(innerattrib)
					#not HABTM
					obj.[]=(innerattrib,val)
				else
					#HABTM
	   				plural_attrib = innerattrib[0,innerattrib.size-3].pluralize
					obj.[](plural_attrib) << val 
				end
				puts 'Set '+innerattrib+' to '+val.to_s if Debug > 5
				return true
			end #id check
		else
			puts "Ignored "+attrib+" in " +obj.class.name if Debug > 0
		end #attribute existence check

	end #addXmlAttribute

	def initialize(contributor = nil)
		#debug
		@resolved = 0
		@unresolved = 0

		#stack of xml attributes
		@stack       = [];

		#whether or not to save next set of characters
		@store_chars = false;

		#source object used throughout
		@source      = nil
		@source_id   = nil

		#array to store id's not resolved from file_internal_id to database id's
		@unresolved_ids = []

		@contrib = contributor

	end

	def on_start_element_ns(element, attributes, prefix, uri, namespaces)
		element.downcase!
		puts "Start "+element.downcase if Debug > 2

		# NOTE: This parsing relies on the simple two-level structure 
		# of VIP data.
		if (@stack.size == 0 && Topelements.include?(element)) then
		   if element == 'source'
		      obj = Source.new
		      @source = obj
		   else
		      raise if @source.nil?
		      obj = element.camelcase.constantize.new
		      obj.source = @source
		   end

		   #store attributes inside start tag
		   attributes.each {|k,v| 
			   puts k if Debug > 4
			   addXmlAttribute(obj,k,v)
		   }
		   @stack.push(obj)

#TODO: optimize insertions
begin  #Stuff for profiling speed
		if (element == 'street_address')
			if @lastelement && @lastelement > 100 then
		#		Profiler__::stop_profile
		#		Profiler__::print_profile($stderr)
				result = RubyProf.stop
				printer = RubyProf::GraphPrinter.new(result)
				printer.print(STDERR, 0)
				Process.exit
			elsif @lastelement then  
				@lastelement += 1
			else
				@lastelement = 1
				RubyProf.start
		#		Profiler__::start_profile
				@lastelement = 1;
			end
		end

		if (false) #profiling stuff
		   if (!@lastelement) then
			@lastelement = element
			@elementcount=0;
			puts element
		   elsif (@lastelement != element)
			@elementcount += 1
			@lastelement = element
                        Profiler__::stop_profile
			Profiler__::print_profile($stderr)
			puts element
			Profiler__::start_profile
		   elsif (@elementcount == 100)
			@elementcount = 0
			Profiler__::print_profile($stderr)
			exit
		   else
			@elementcount += 1
	           end
		end
end			

		elsif (@stack.size == 1) then # && Innerelements.include?(element)) then
			   @stack.push(String.new(element))
			   @stack.push(String.new())
			   @store_chars = true
		else
			puts "Ignoring element: "+element if Debug > 0
		end

	end

	def on_characters(chars)
		if (@store_chars) then
			buffer = @stack.pop
#			buffer = @stack.last
			buffer += chars
			@stack.push(buffer)
		end
	end

	def on_end_document()
		#resolve IDs.  Might add internal_file_id to unresolved_ids record as a check
		unresolved_ids = @source.unresolved_ids
#		puts unresolved_ids.size if Debug > 1

		puts @unresolved_ids.size.to_s + " unresolved IDs" if Debug > 3

		unresolved_ids.each do |u|
			obj = u.object_class.constantize.find_by_id(u.object_id)	
			if (addXmlAttribute(obj,u.parameter,u.val)) then	
				puts "Resolved" if Debug > 3
				obj.save
				u.destroy
			end
		end

		puts @unresolved_ids.size.to_s + " unresolved IDs" if Debug > 3

		# add state_id to streets.  these eases later lookup
		addresses = @source.street_addresses
		addresses.each do |addr|
			addr.state = addr.street_segments.first.precinct.locality.state
			addr.save
		end

		@source.import_completed_at = Time.now
		@source.contrib = @contrib unless @contrib.nil?
		@source.save

		# MySQL specific one-liner
#		@source.connection.execute("UPDATE street_addresses sa, 
#                                                   street_segments ss, 
#                                                   precincts p, 
#                                                   localities l 
#                                            SET    sa.state_id = l.state_id
#		                            WHERE  sa.id IN (ss.start_street_address_id, ss.end_street_address_id)
#		                              AND  ss.precinct_id = p.id
#		                              AND  p.locality_id = l.id
#		                              AND  sa.source_id = #{@source.id}")

	end

	def on_end_element_ns(element, prefix, uri)

		if (@store_chars) then
			chars   = @stack.pop
			element = @stack.pop
			obj     = @stack.last
			addXmlAttribute(obj,element,chars)
			@store_chars = false;
		else
			puts "End "+element+" \n " + @stack.size.to_s if Debug>2
#			if ["source", "precinct"].include?(element.downcase) then
			if @stack.size == 1 then
				obj = @stack.pop
#				if element == 'street_address' then
#					obj.connection.execute ("INSERT INTO street_addresses SET 
#                                                    source_id = #{obj.source.id},
#					            file_internal_id = #{obj.file_internal_id},
#					            house_number = #{obj.house_number}, 
#					            street_direction = #{obj.street_direction} ,
#					            street_name = #{obj.street_name}, 
#					            street_suffix = #{obj.street_suffix}, 
#					            address_direction = #{obj.address_direction}, 
#					            apartment = #{obj.apartment}, 
#					            city = #{obj.city}, 
#					            zip = #{obj.zip}")
#				else
					if (obj.save(false)) then
						if element == 'source' then
							@source_id = obj.id
						end
#						puts "Saving #{element} with #{@unresolved_ids.size} unresolved ids"
						UnresolvedId.transaction do
							@unresolved_ids.each do |u|
								u.object_id = obj.id
								u.save(false)
							end
			   				@unresolved_ids = []
						end #transaction
						puts "file_internal_id: " + obj.file_internal_id.to_s if Debug > 3
						puts "saved" if Debug > 4
					else
						puts element + ' not saved.  Id: '+obj.file_internal_id.to_s if Debug > 3
					end #if obj.save
#				end #element == street_address
			end #stack.size == 1
		end #store_chars
	end

	def method_missing(method_name, *attributes, &block)
	end
end
