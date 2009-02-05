class VipParser
	require 'rubygems'
	require 'libxml'

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
