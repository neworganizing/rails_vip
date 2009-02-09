namespace :vip_parsing do

	task :parse => :environment do

		require 'vip_parser'
		xmlfile = '/mysqlvol/rails/ks.xml'
		parser.callbacks = VipParser.new(xmlfile)
		parser.parse
	end
	task :model_parse => :environment do

		require 'vip_parser'
		s = Source.new
#		s.import('http://www.votinginfoprojectdata.org/data/vipFeed-19/vipFeed-19-2008-10-23T14-18-42.xml.zip')
		s.import('http://election-info-standard.googlecode.com/files/sample%20feed%20for%20v1.5.xml','../sample1_5.xml')
	end
end
