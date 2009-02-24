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

	has_one :feed_contact, :class_name => 'ElectionOfficial'

	def import(url, file)
		@url = url

		con = LibXML::XML::Parser::Context.file(file)

		@parser           = LibXML::XML::SaxParser.new(con)
		@parser.callbacks = VipHandler.new
		@parser.parse
	end

	def activate!
		self.active = 1
		self.save
	end
	def deactivate!
		self.active = 0
	end
	def active?
		(self.active == 1) ? true : false
	end
end
