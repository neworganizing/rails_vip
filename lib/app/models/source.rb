class Source < ActiveRecord::Base
	require 'libxml'
	require 'vip_handler'

	belongs_to :contrib
	has_many :ballot_drop_locations
	has_many :custom_notes
	has_many :election_administrations
	has_many :election_officials
	has_many :elections
	has_many :localities
	has_many :precincts
	has_many :contests
	has_many :states
	has_many :street_addresses
	has_many :street_segments
	has_many :tabulation_areas
	has_many :unresolved_ids
	has_many :custom_notes, :as => :object

	belongs_to :feed_contact, :class_name => 'ElectionOfficial'

	# takes a url and a file to create a new source.  The file is parsed
	# by VipHandler, and the url is stored with the source.
	def import(file, url = nil)

		@url = url

		# set the LibXML context for parsing
		con = LibXML::XML::Parser::Context.file(file)

		@parser           = LibXML::XML::SaxParser.new(con)
		@parser.callbacks = VipHandler.new
		@parser.parse
	end

	# activate the source. inactive sources can be ignored
	def activate!
		self.active = 1
		self.save
	end

	# activate the source. inactive sources can be ignored
	def deactivate!
		self.active = 0
	end

	# returns true if the source is active, false otherwise
	def active?
		(self.active == 1) ? true : false
	end
end
