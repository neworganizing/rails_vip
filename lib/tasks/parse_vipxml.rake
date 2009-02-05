namespace :vip_parsing do

task :parse => :environment do

require 'rubygems'
require 'libxml'

#require 'ruby-prof'

class VipHandler 
	# Parses Voting Information Project format version 1.4
	include LibXML::XML::SaxParser::Callbacks

	Debug = 1   #debug level
#	ObjBlock = 1000
	
	# defines which top-level elements to parse
	Topelements = ["source","state",
	               "locality","precinct",
	               "polling_location","street_segment",
	               "street_address"]

	# don't try to map the following ID elements to objects
	IdExceptions = ["vip_id", "file_internal_id"]

#	Innerelements = ["id","vip_id","datetime","description","locality_id",
#	                 "name", "ward","mail_only","polling_location_id"]

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

#		TODO: Should use the has_attribute check below, but assume the XML is valid for now...
#		if obj.has_attribute?(innerattrib) then

#			if (@id_regex.match(innerattrib) && !IdExceptions.include?(innerattrib))
			if (innerattrib[-3,3] == '_id' && !IdExceptions.include?(innerattrib))
				#this is an ID in the file we need to map
				#to the database's internal ID
#				attribute_type = Regexp.last_match(1)
				attribute_type = innerattrib[0,innerattrib.size-3]
#				if (@address_regex.match(attribute_type)) then
				if (attribute_type.length >= 14 && attribute_type[-14,14] == 'street_address') then
					attribute_type = 'street_address'
				end
				referenced_obj = attribute_type.camelcase.constantize.find(:first, 
				                    :conditions => "source_id = #{@source_id} AND file_internal_id = #{val}")
#				referenced_obj = attribute_type.camelcase.constantize.find_by_sql(
#						    "SELECT t.id FROM #{attribute_type.tableize} t
#				                     WHERE source_id = #{@source_id} AND file_internal_id = #{val}
#				                     LIMIT 1")

				if (referenced_obj.nil?)
					# we haven't found the referenced ID in the stack yet.
					# Add it to a table storing unresolved objects
					badone = UnresolvedId.new do |u|
						u.source       = @source
#						u.object_class = attribute_type.camelcase
						u.object_class = obj.class.name
						u.parameter    = attrib
					end

					# save it to a stack.  We'll store it when the object gets an ID
					@unresolved_ids.push(badone)
#					@unresolved+=1
					puts 'Added '+innerattrib+' to resolution list.  Fail #'+@unresolved.to_s if Debug > 3
					# save file_internal_id in place of object id
					obj.[]=(innerattrib,val)
					return false
				else
					# store object id
					obj.[]=(innerattrib,referenced_obj.id)
#					@resolved+=1
					puts 'Set '+innerattrib+' to valid object.  Success #'+@resolved.to_s if Debug > 3
					return true
				end
					
#			elsif (innerattrib.eql?('file_internal_id')) then
#				#make sure we store a string and not an object
#				obj.[]=(innerattrib,val.to_i)
#				puts 'Set '+innerattrib+' to '+val.to_s if Debug > 3

			else #just a normal attribute, not an object reference
				obj.[]=(innerattrib,val)
				puts 'Set '+innerattrib+' to '+val.to_s if Debug > 4
				return true
			end
#		end

	end

	def initialize()
		#debug
		@resolved = 0
		@unresolved = 0

		@stack       = [];
		@store_chars = false;
		@source      = nil
		@source_id   = nil

		@unresolved_ids = []

		#an array to store ObjBlock at a time
#		@obj_store = []
#		@obj_store_class = ''

#		@save        = false;
#		@contrib = contributor

#		@id_regex = Regexp.new('(.*)_id$', true)
#		@address_regex = Regexp.new('street_address$', true)
	end

	def on_start_element_ns(element, attributes, prefix, uri, namespaces)
		element.downcase!
		puts "Start "+element.downcase if Debug > 2
		# Note: This parsing relies on the simple two-level structure 
		# of VIP data.
		if (@stack.size == 0 && Topelements.include?(element)) then
		   case element
			   when "source"   ; begin 
				              obj = Source.new
					      @source = obj
					     end
			   when "precinct" ; begin
				               obj = Precinct.new
					       raise if @source.nil? 
					       obj.source = @source
					     end
			   when "polling_location" ; begin
				               obj = PollingLocation.new
					       raise if @source.nil? 
					       obj.source = @source
					     end
			   when "street_segment" ; begin
				               obj = StreetSegment.new
					       raise if @source.nil?
					       obj.source = @source
			                     end
			   when "state" ; begin
				               obj = State.new
					       raise if @source.nil?
					       obj.source = @source
			                     end
			   when "locality" ; begin
				               obj = Locality.new
					       raise if @source.nil?
					       obj.source = @source
			                     end
			   when "street_address" ; begin
				               obj = StreetAddress.new
					       raise if @source.nil?
					       obj.source = @source
			                     end

		   end #case

#TODO: optimize insertions
=begin  #Stuff for profiling speed
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
=end			

		   attributes.each {|k,v| 
			   puts k if Debug > 4
			   addXmlAttribute(obj,k,v)
		   }
		   @stack.push(obj)

		elsif (@stack.size == 1) then # && Innerelements.include?(element)) then
			   @stack.push(String.new(element))
			   @stack.push(String.new())
			   @store_chars = true
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

		unresolved_ids.each do |u|
			obj = u.object_class.constantize.find_by_id(u.object_id)	
			if (addXmlAttribute(obj,u.parameter,obj[u.parameter])) then	
				obj.save
				u.destroy
			end
		end

		@source.import_completed_at = Time.now
		@source.save
		puts @unresolved_ids.size

		# add state_id to streets
		# MySQL Specific!
		@source.connection.execute("UPDATE street_addresses sa, 
                                                   street_segments ss, 
                                                   precincts p, 
                                                   localities l 
                                            SET    sa.state_id = l.state_id
		                            WHERE  sa.id IN (ss.start_street_address_id, ss.end_street_address_id)
		                              AND  ss.precinct_id = p.id
		                              AND  p.locality_id = l.id
		                              AND  sa.source_id = #{@source.id}")

	end

	def on_end_element_ns(element, prefix, uri)

		if (@store_chars) then
			chars   = @stack.pop
			element = @stack.pop
			obj     = @stack.last
			addXmlAttribute(obj,element,chars)
			@store_chars = false;
		else
			puts "\tEnd "+element+" \n " + @stack.size.to_s if Debug>3
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

class VipParser
#	def initialize(contrib, xmlfile)
	def initialize(xmlfile)
		con = LibXML::XML::Parser::Context.file(xmlfile)
		@parser = LibXML::XML::SaxParser.new(con)
		@parser.callbacks = VipHandler.new
	end

	def parse
		@parser.parse
	end
end

#parser = VipParser.new(contrib,'/mysqlvol/rails/google_vip/ks.xml')
parser = VipParser.new('/mysqlvol/rails/google_vip/ks.xml')
parser.parse
end

task :resolve_ids => :environment do
	IdExceptions = ["vip_id", "file_internal_id"]
	Debug = 5
	def addXmlAttribute(obj, attrib, val)
		if (attrib.eql?("id"))
			puts attrib if Debug > 4
			innerattrib = "file_internal_id"
		else
			innerattrib = attrib
		end

#		TODO: Should use the has_attribute check below, but assume the XML is valid for now...
#		if obj.has_attribute?(innerattrib) then

#			if (@id_regex.match(innerattrib) && !IdExceptions.include?(innerattrib))
			if (innerattrib[-3,3] == '_id' && !IdExceptions.include?(innerattrib))
				#this is an ID in the file we need to map
				#to the database's internal ID
#				attribute_type = Regexp.last_match(1)
				attribute_type = innerattrib[0,innerattrib.size-3]
#				if (@address_regex.match(attribute_type)) then
				if (attribute_type.length >= 14 && attribute_type[-14,14] == 'street_address') then
					attribute_type = 'street_address'
				end
				referenced_obj = attribute_type.camelcase.constantize.find(:first, 
				                    :conditions => "source_id = #{@source_id} AND file_internal_id = #{val}")
#				referenced_obj = attribute_type.camelcase.constantize.find_by_sql(
#						    "SELECT t.id FROM #{attribute_type.tableize} t
#				                     WHERE source_id = #{@source_id} AND file_internal_id = #{val}
#				                     LIMIT 1")

				if (referenced_obj.nil?)
					# we haven't found the referenced ID in the stack yet.
					# Add it to a table storing unresolved objects
					badone = UnresolvedId.new do |u|
						u.source       = @source
#						u.object_class = attribute_type.camelcase
						u.object_class = obj.class.name
						u.parameter    = attrib
					end

					# save it to a stack.  We'll store it when the object gets an ID
					@unresolved_ids.push(badone)
#					@unresolved+=1
					puts 'Added '+innerattrib+' to resolution list.  Fail #'+@unresolved.to_s if Debug > 3
					# save file_internal_id in place of object id
					obj.[]=(innerattrib,val)
					return false
				else
					# store object id
					obj.[]=(innerattrib,referenced_obj.id)
#					@resolved+=1
					puts 'Set '+innerattrib+' to valid object.  Success #'+@resolved.to_s if Debug > 3
					return true
				end
					
#			elsif (innerattrib.eql?('file_internal_id')) then
#				#make sure we store a string and not an object
#				obj.[]=(innerattrib,val.to_i)
#				puts 'Set '+innerattrib+' to '+val.to_s if Debug > 3

			else #just a normal attribute, not an object reference
				obj.[]=(innerattrib,val)
				puts 'Set '+innerattrib+' to '+val.to_s if Debug > 4
				return true
			end
#		end

	end
		@unresolved_ids = []
		@source_id=5
		@source = Source.find_by_id(@source_id)
		unresolved_ids = @source.unresolved_ids
#		puts unresolved_ids.size if Debug > 1

		unresolved_ids.each do |u|
			obj = u.object_class.constantize.find_by_id(u.object_id)	
			if (addXmlAttribute(obj,u.parameter,obj[u.parameter])) then	
				obj.save
				u.destroy
			end
		end

		@source.import_completed_at = Time.now
		@source.save
		puts @unresolved_ids.size
end
end
