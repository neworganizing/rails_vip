class Source < ActiveRecord::Base
	require 'vip_handler'
	require 'libxml'

	belongs_to :contrib
	has_many :ballot_drop_locations
	has_many :custom_notes
	has_many :election_administrations
	has_many :election_officials
	has_many :localities
	has_many :precincts
	has_many :states
	has_many :street_addresses
	has_many :street_segments
	has_many :tabulation_areas
	has_many :unresolved_ids

	def import(url, file = nil)

		@url = url


		#TODO: this belongs in a controller.  force the file to be parsed already.
		if file.nil? then #download file from url
			require 'net/http'		
			require 'uri'
			uri = URI.parse(url)
			puts uri.host
			puts uri.path

			/\/([^\/]*?)$/ =~ uri.path.to_s
			filename = Regexp.last_match(1)
			puts filename

			/\.([^.]*?)$/ =~ uri.path.to_s
			filetype = Regexp.last_match(1)
			puts filetype
			
			#make a temporary path for the file
			temppath = "downloads/" 
			pathchars = ("a".."z").to_a
			1.upto(20) { |i| temppath << pathchars[rand(pathchars.size - 1)] }

			puts temppath
			puts filename
			FileUtils.mkdir_p temppath
			fullfile = temppath + '/' + filename

			Net::HTTP.start (uri.host) { |http|
				resp = http.get(uri.path)
				open(fullfile, "wb") { |file|
					file.write(resp.body)
				}
			}
			if (filetype == 'zip') then
				require 'zip/zip'
				xmlfile = fullfile[0 .. fullfile.length - 5]
				xmlname = filename[0 .. filename.length - 5]
				open(xmlfile, "wb") { |file|
					Zip::ZipFile.open(fullfile) {|f|
						file.write(f.read(xmlname))
					}
				}
			else
				xmlfile = fullfile
			end
		end

		con = LibXML::XML::Parser::Context.file(xmlfile)
		@parser = LibXML::XML::SaxParser.new(con)
		@parser.callbacks = VipHandler.new
		@parser.parse
	end
end
