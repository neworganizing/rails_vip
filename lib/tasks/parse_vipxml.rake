namespace :vip_parsing do

	task :parse => :environment do

		require 'vip_parser'

		xmlfile = '/mysqlvol/rails/ks.xml'
		parser.callbacks = VipParser.new(xmlfile)
		parser.parse
	end
end
