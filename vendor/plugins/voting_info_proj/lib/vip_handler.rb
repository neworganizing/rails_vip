class VipHandler 
	# Parses Voting Information Project format version 1.4
	
	require 'rubygems'
	require 'ruby-prof'	
	require 'libxml'

	include LibXML::XML::SaxParser::Callbacks

	Debug = ENV['VIP_DEBUG'].to_i || 0   #debug level

	
	# defines which top-level elements to parse
	TopElements = ["source","state",
	               "locality","precinct", "election",
	               "precinct_split", "election_administration",
	               "election_official", "ballot_drop_location",
	               "contest","candidate","campaign_issue",
	               "candidate_statement","custom_ballot",
	               "custom_note","referendum",
	               "polling_location","street_segment",
	               "street_address", "ballot","ballot_response",
	               "tabulation_area"]

	# don't try to map the following ID elements to objects
	IdExceptions = ["vip_id", "file_internal_id"]

	def save_unresolved(obj,attrib,val)
		# Add it to a table storing unresolved objects
		badone = UnresolvedId.new do |u|
			u.source       = @source
			u.object_class = obj.class.name
			u.parameter    = attrib
			u.val          = val
		end

		# save it to a stack.  We'll store it when the object gets an ID
		@unresolved_ids.push(badone)

		puts 'Added '+attrib+' to resolution list.  Fail.' if Debug > 3
	end

	def store_arbitrary_object_reference(obj,object_id, store_unresolved)
		(TopElements-["source"]).each do |top|
			puts "trying "+top+" class" if Debug > 4
			lookup_class = top.camelize.constantize
			referenced_obj = lookup_class.find(:first, 
			                                   :conditions => ["source_id = ? AND file_internal_id = ?", 
			                                                   @source.id, object_id])
			puts "got it" if Debug > 4 and !referenced_obj.nil?
			if !referenced_obj.nil?
				puts "Found: "+lookup_class.name+"\t"+referenced_obj.id.to_s if Debug > 4
				obj.object_type = lookup_class.name
				obj.object_id   = referenced_obj.id	
				return true
			end
		end

		# we haven't found the referenced ID in the stack yet.
		# Add it to a table storing unresolved objects
		if store_unresolved
			save_unresolved(obj,"object_id",object_id)
		end

		# save file_internal_id in place of object id, unless it's HABTM
		obj.[]=(innerattrib,val) if obj.has_attribute?(innerattrib)

		return false
	end


	def get_object_by_file_internal_id(obj, attrib, file_internal_id, external_vip_id, external_datetime)

		#grab attribute type from innerattrib (drop _id)
		attribute_type = attrib[0,attrib.size-3]
		puts attribute_type if Debug > 3

		#get the class corresponding to the parameter	
		attr_reflection =   obj.class.reflect_on_association(attribute_type.to_sym)	
		attr_reflection ||= obj.class.reflect_on_association(attribute_type.pluralize.to_sym)	

		attribute_class = attr_reflection.klass 
		obj_source = @source

		#TODO: test external links functionality
		# look up the external source if it's referenced
		if (external_vip_id and external_datetime) then
			puts "External" if Debug > 3
			obj_source = Source.find(:first, :conditions => 
						 ["date = ? AND vip_id = ?", 
		                                  external_datetime,
		                                  external_vip_id])
		end

		#find the referenced object.  only grab the id...we just save a ref to the object
		obj_source.nil? ? nil : attribute_class.find(:first, 
		                                             :conditions => ["source_id = ? AND file_internal_id = ?", 
		                                                             obj_source.id, file_internal_id ], 
		                                             :select => "id")
	end

	# Takes attrib as the element from xml with val as it's value.
	# Assumes that element name is the class attribute name, except in 
	# the case of id's. 
	# * Maps element's ID to file_internal_id
	# * Overwrites IDs referenced by elements to database internal IDs
	def add_xml_attribute(obj, attrib, val, store_unresolved = true, external_vip_id = nil, external_datetime = nil)
		#don't store unnecessary white space
		val.strip!

		if (attrib.eql?("id"))
			puts attrib if Debug > 4
			innerattrib = "file_internal_id"
		else
			innerattrib = attrib
		end

		# if it's an object_id, it's probably a custom_note
		# don't try to resolve it until the end of the document
		if innerattrib.eql?("object_id") then

			puts "object_id" if Debug > 4

			if store_arbitrary_object_reference(obj,val,store_unresolved)
				return true
			end

		# store object if it exists
		#TODO: size-3 or size-4?
		elsif obj.respond_to?(innerattrib) or 
		   obj.respond_to?(innerattrib[0,innerattrib.size-3].pluralize) then

			if (innerattrib[-3,3] == '_id' && !IdExceptions.include?(innerattrib))

				#this is an ID in the file we need to map
				#to the database's internal ID
				referenced_obj = get_object_by_file_internal_id(obj, attrib, val, 
				                                                external_vip_id, external_datetime)
				puts referenced_obj.inspect if Debug > 9

				if !referenced_obj.nil? then
					# store object id
					if obj.has_attribute?(innerattrib) #!HABTM?
						#not HABTM
						puts "Adding singular object " + innerattrib if Debug > 4
						obj.[]=(innerattrib,referenced_obj.id)
					else
						#HABTM
						puts "Adding plural object " + innerattrib if Debug > 4
						#TODO: size-3 or size-4?
		   				plural_attrib = innerattrib[0,innerattrib.size-3].pluralize
						
						eval('obj.'+plural_attrib).push referenced_obj
					end

					puts 'Set '+innerattrib+' to valid object.  Success.' if Debug > 3
					return true

				else #referenced object is nil
					# we haven't found the referenced ID in the stack yet.
					if store_unresolved
						save_unresolved(obj,attrib,val)
					end

					# save file_internal_id in place of object id, unless it's HABTM
					obj.[]=(innerattrib,val) if obj.has_attribute?(innerattrib)

					return false

				end #if referenced_obj.nil?
					
			else #just a normal attribute, not an object reference

				obj.[]=(innerattrib,val)

				puts 'Set '+innerattrib+' to '+val.to_s if Debug > 5

				return true

			end #id check
		else #attribute doesn't apply here
			puts "Ignored "+attrib+" in " +obj.class.name if Debug > 0
		end #attribute existence check

	end #add_xml_attribute


	# sets several variables used in the rest of the application.  also
	# links source to contributor if defined
	def initialize(contributor = nil)
		#stack of xml elements and attributes
		@stack       = [];

		#whether or not to save next set of characters
		@store_chars = false;

		#source object used throughout
		@source      = nil

		#array to store id's not resolved from file_internal_id to database id's
		@unresolved_ids = []

		@contrib = contributor
	end

	# this parser callback function decides where to send a new element.  If the parser
	# is not already in a top-level element, it will process if the element is in 
	# TopElements. If we are in a top-level element, it directs the parser to start
	# storing characters.  Additionally, if attributes are specified within tags, it 
	# directs them to add_xml_attribute
	def on_start_element_ns(element, attributes, prefix, uri, namespaces)
		element.downcase!
		puts "Start "+element.downcase if Debug > 2

		# NOTE: This parsing relies on the simple two-level structure 
		# of VIP data.
		if (@stack.size == 0 && TopElements.include?(element)) then
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
			   add_xml_attribute(obj,k,v)
		   }
		   @stack.push(obj)

		elsif (@stack.size == 1) then # && Innerelements.include?(element)) then
			   @stack.push(String.new(element))
			   @stack.push(String.new())
			   @store_chars = true
		else
			puts "Ignoring element: "+element if Debug > 0
		end

	end

	# store characters as they come inside an element. This may be called
	# more than once within an element. 
	def on_characters(chars)
		if (@store_chars) then
			#TODO: why can't we just edit @stack.last ?
			buffer = @stack.pop
			buffer += chars
			@stack.push(buffer)
		end
	end

	# once all elements have been parsed, looks through unresolved_ids for objects that
	# had not been stored yet. Also timestamps end of source import and appends state to 
	# street_address field 
	def on_end_document()

		if ['PostgreSQL','MySQL'].include?(@source.connection.adapter_name) then
			resolve_ids_sql
			#resolve_ids_activerecord
		else
			resolve_ids_activerecord
		end
		
		puts UnresolvedId.count(:conditions => {:source_id => @source.id}).to_s + " unresolved IDs" if Debug > 3

		# add state_id to streets.  this eases later lookup
		# We use a shortcut when we can, rails convention if we're not sure
		if ['PostgreSQL','MySQL'].include?(@source.connection.adapter_name) then
			add_state_to_addresses_sql
		else
			add_state_to_addresses_activerecord
		end

		@source.import_completed_at = Time.now
		@source.contrib = @contrib unless @contrib.nil?
		@source.activate!
		@source.save

	end
	
	# updates new street_addresses with state_id to speed lookups.  uses SQL for speed
	def add_state_to_addresses_sql
		['ss.start_street_address_id','ss.end_street_address_id'].each do |addr_id_col|
			@source.connection.execute("UPDATE street_addresses sa
       	                                     SET    sa.state_id = (
			                       SELECT l.state_id
					 	 FROM street_segments ss, 
       	                                              precincts p, 
       	                                              localities l 
			                        WHERE sa.id = #{addr_id_col}
			                          AND ss.precinct_id = p.id
			                          AND p.locality_id = l.id LIMIT 1)
			                     WHERE sa.state_id IS NULL
		                               AND sa.source_id = #{@source.id}")
		end
	end


	# updates new street_addresses with state_id to speed lookups.  uses ActiveRecord for compatibility
	def add_state_to_addresses_activerecord
		addresses = StreetAddress.find(:all, :select => "id", 
		                               :conditions => ["source_id = ? AND state_id IS NULL", @source.id])
		addresses.each do |address|
			addr = StreetAddress.find(address.id)
			addr.state = addr.street_segments.first.precinct.locality.state
			addr.save
		end
	end

	# go through unresolved IDs and try to match to real objects.  if classlist is set, 
	# only attempt to resolve those classes. uses ActiveRecord for compatibility
	def resolve_ids_activerecord(classlist = nil)
		#TODO: switch to UnresolvedId.each with rails 2.3
		
		#TODO: a rails bug is preventing the line from being written like this:
#		conditions = {:source => @source}

		conditions = {"source_id" => @source.id}
		if classlist
			conditions[:object_class] = classlist
		end
		
		unresolved_ids = UnresolvedId.find(:all, :select => "id", 
		                                   :conditions => conditions)
		puts unresolved_ids.size.to_s + " unresolved to loop" if Debug > 4
		unresolved_ids.each do |unresolved|
			#load the rest of the record/object
			u = UnresolvedId.find(unresolved.id)

			obj = u.object_class.constantize.find_by_id(u.object_id)	
			if (add_xml_attribute(obj,u.parameter,u.val.to_s,false)) then	
				puts "Resolved" if Debug > 3
				obj.save
				u.destroy
			elsif Debug > 3
				puts "Not Resolved: "+obj.class.name+"\t"+u.object_id.to_s+"\t"+u.parameter.to_s+"\t"+u.val.to_s
			end
		end
	end

	# go through unresolved IDs and try to match to real objects.  uses SQL for speed
	def resolve_ids_sql
		(TopElements-["custom_note", "tabulation_area"]).each do |element|
			paramlist = UnresolvedId.count(:parameter, :group => "parameter",
			                               :conditions => ["source_id = ? AND object_class = ?", 
			                                              @source.id, element.camelcase])	
			paramlist.each do |param,cnt|
				#all params are ids, chop the last 3
				param_name = param[0 .. param.size - 4]

				#get the type of association
				element_klass = element.camelcase.constantize
				assoc   = element_klass.reflect_on_association(param_name.to_sym)
				assoc ||= element_klass.reflect_on_association(param_name.pluralize.to_sym)
				raise "no reflection between "+element_klass.name+" and "+param_name+" or "+param_name.pluralize unless assoc

				param_class = assoc.class_name
				case assoc.macro
					when :has_and_belongs_to_many
						insert_table = [element_klass.name.tableize, param_class.tableize].sort.join("_")
						resolve_ids_habtm_sql(@source, element_klass, param, param_class, insert_table)
					when :belongs_to
						resolve_ids_belongs_to_sql(@source, element_klass, param, param_class)
					when :has_many
						if assoc.options.keys.include?(:through)
							insert_table = assoc.options[:through].to_s.tableize
							puts "through: "+insert_table
							resolve_ids_habtm_sql(@source, element_klass, param, param_class, insert_table)
						else
							raise "unexpected association macro type :has_many "+element_klass.name+" and "+param_name
						end
					when :has_one
						raise "unexpected association macro type :has_one between "+element_klass.name+" and "+param_name
				end #case

			end #each param
		end #each TopElement
		resolve_ids_activerecord(["CustomNote","TabulationArea"])
	end #method

	
	# resolves HABTM ids. uses SQL for speed
	def resolve_ids_habtm_sql(source, klass, param, param_class, insert_table)

		temptable = resolve_ids_temptable_sql (source, klass, param, param_class)

		source.connection.execute "
			INSERT INTO #{insert_table} (#{klass.name.underscore + "_id"}, #{param}) 
				SELECT object_id, param_id FROM #{temptable};"

		resolve_ids_cleanup_sql(source, temptable)

		return true
	end

	# resolves belongs_to ids. uses SQL for speed
	def resolve_ids_belongs_to_sql(source, klass, param, param_class)

		temptable = resolve_ids_temptable_sql (source, klass, param, param_class)

		update_statement = "
		UPDATE #{klass.name.tableize} SET #{param} = (
		 SELECT param_id FROM #{temptable} WHERE object_id=#{klass.name.tableize}.id)" 
		update_statement += " WHERE source_id = #{source.id}" if klass.name != "Source"

		source.connection.execute update_statement

		resolve_ids_cleanup_sql(source, temptable)

		return true
	end

	# get rid of the resolved ids and table
	def resolve_ids_cleanup_sql(source, temptable)
		source.connection.execute "
		DELETE FROM unresolved_ids 
		      WHERE EXISTS (SELECT 1 FROM #{temptable} 
		                     WHERE unresolved_id = unresolved_ids.id)
		            AND source_id = #{source.id};"

		source.connection.execute "DROP TABLE #{temptable}"
	end
		

	#join unresolved ids with the temporary table
	def resolve_ids_temptable_sql(source, klass, param, param_class)

		temptable = "resolution" + rand(30000).to_s
		object_class = klass.name
		object_table = object_class.tableize
		parameter_table = param_class.tableize

		source.connection.execute "
		CREATE TEMPORARY TABLE #{temptable} 
		SELECT unresolved_ids.id as unresolved_id, object_table.id AS object_id, parameter_table.id AS param_id
		  FROM #{object_table} AS object_table, 
		       #{parameter_table} AS parameter_table,
		       unresolved_ids
		 WHERE unresolved_ids.object_id = object_table.id
		   AND unresolved_ids.object_class = '#{object_class}'
		   AND unresolved_ids.val = parameter_table.file_internal_id
		   AND unresolved_ids.parameter = '#{param}'
		   AND parameter_table.source_id = #{source.id}
		   AND unresolved_ids.source_id = #{source.id};"

		return temptable
	end

	# if an attribute of a top-level element, sends attribute and characters to 
	# add_xml_attribute.  If the end of a top-level element, saves the object
	def on_end_element_ns(element, prefix, uri)

		if (@store_chars) then
			chars   = @stack.pop
			element = @stack.pop
			obj     = @stack.last
			add_xml_attribute(obj,element,chars)
			@store_chars = false;
		else
			puts "End "+element+" \n " + @stack.size.to_s if Debug>2
			if @stack.size == 1 then
				obj = @stack.pop
				if (obj.save(false)) then
#					puts "Saving #{element} with #{@unresolved_ids.size} unresolved ids"
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
			end #stack.size == 1
		end #store_chars
	end

	def method_missing(method_name, *attributes, &block)
	end
end
