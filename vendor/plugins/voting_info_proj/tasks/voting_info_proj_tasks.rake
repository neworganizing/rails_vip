namespace :vip do

	desc "Load in a new VIP source file.  If VIP_FILE is set to a local file, this file will be imported and VIP_URL (if set) will be stored for reference.  If VIP_URL is set and VIP_FILE is not, the file at the URL will be downloaded and then imported."
	task :parse => :environment do
		s = Source.new
		url  = ENV['VIP_URL'] || '' #we can live without the URL

		file = ENV['VIP_FILE']    

		if (file.nil? or file.eql?('')) and (url.nil? or url.eql?(''))
			puts "ERROR: Must set VIP_URL or VIP_FILE environment variables"
			exit 0
		end

#		url = 'http://www.votinginfoprojectdata.org/data/vipFeed-19/vipFeed-19-2008-10-23T14-18-42.xml.zip')
#		file = '../sample1_5.xml'

		if file.nil? then #download file from url
			require 'net/http'		
			require 'uri'

			uri = URI.parse(url)

			# get the file name
			/\/([^\/]*?)$/ =~ uri.path.to_s
			filename = Regexp.last_match(1)

			# get the extension
			/\.([^.]*?)$/ =~ uri.path.to_s
			filetype = Regexp.last_match(1)
			
			#make a temporary path for the file
			temppath = "downloads/" 
			pathchars = ("a".."z").to_a
			1.upto(20) { |i| temppath << pathchars[rand(pathchars.size - 1)] }

			FileUtils.mkdir_p temppath
			fullfile = temppath + '/' + filename

			open(fullfile, "wb") { |file|
				Net::HTTP.start(uri.host) { |http|
					resp = http.get(uri.path)
					file.write(resp.body)
				}
			}
			if (filetype == 'zip') then #unzip
				require 'zip/zip'

				#assume that the .zip file is named the same as the file it contains
				xmlfile = fullfile[0 .. fullfile.length - 5]
				xmlname = filename[0 .. filename.length - 5]
				unless (xmlname[xmlname.length - 3 .. xmlname.length - 5].eql?("xml"))
					xmlname = xmlname + ".xml"
				end
				open(xmlfile, "wb") { |fyle|
					Zip::ZipFile.open(fullfile) {|f|
						fyle.write(f.read(xmlname))
					}
				}
				file = xmlfile
			else #wasn't zipped
				file = fullfile
			end
		end
		s.import(url,file)
	end

	task :source_deactivate => :environment do
		if (!ENV['VIP_SID'])
			puts "USAGE:\n     rake vip:source_deactivate VIP_SID=<source_id>"
		end
		@source = Source.find(ENV['VIP_SID'])
		@source.deactivate!
		@source.save
	end #task	
	task :source_activate => :environment do
		if (!ENV['VIP_SID'])
			puts "USAGE:\n     rake vip:source_activate VIP_SID=<source_id>"
		end
		@source = Source.find(ENV['VIP_SID'])
		@source.activate!
		@source.save
	end #task	
	task :active_sources => :environment do
		@sources = Source.find(:all, :conditions => "active = 1")
		puts "ID\timport date\tname"
		@sources.each do |s|
			puts "#{s.id}\t#{s.created_at}\t#{s.name}"
		end
	end #task	
end
