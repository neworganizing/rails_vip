class StreetAddress < ActiveRecord::Base
	has_many :start_street_segments, :class_name => 'StreetSegment', :foreign_key => 'start_street_address_id'
	has_many :end_street_segments, :class_name => 'StreetSegment', :foreign_key => 'end_street_address_id'
	belongs_to :source
	belongs_to :state

	def street_segments
		start_street_segments + end_street_segments
	end

	# standardize address into database
	def before_create
		# standardize/split house number
		housematch = Regexp.new('(\d*)((.*?)+)', true)
		housematch.match(house_number)
		self.std_house_number      = Regexp.last_match(1).to_i
		self.std_house_number_suff = Regexp.last_match(2).nil? || Regexp.last_match(2).eql?("") ? nil : Regexp.last_match(2) 

		# split street name
		# search for already established suffixes if they're available
		suff_search = street_suffix.nil? ? StreetSuffixes.join('|') : street_suffix 
		street_direction_search   = street_direction.nil? ?  Directions.join('|') : street_direction
		addr_direction_search     = address_direction.nil? ? Directions.join('|') : address_direction
		
		address_split_regex_str = "^((#{street_direction_search}) )?(.*?)( (#{suff_search}))?( (#{addr_direction_search}))?$"
		address_split_regex = Regexp.new(address_split_regex_str,true)
		
		address_split_regex.match(street_name)
		puts address_split_regex_str
		puts street_name
		
		self.street_direction  ||= Regexp.last_match(1).nil? || Regexp.last_match(1).eql?('') ? nil : Regexp.last_match(2) 
		self.std_street_name     = Regexp.last_match(3).nil? || Regexp.last_match(3).eql?('') ? nil : Regexp.last_match(3) 
		self.street_suffix     ||= Regexp.last_match(4).nil? || Regexp.last_match(4).eql?('') ? nil : Regexp.last_match(5) 
		self.address_direction ||= Regexp.last_match(6).nil? || Regexp.last_match(6).eql?('') ? nil : Regexp.last_match(7) 
		puts self.std_street_name
	end


	StreetSuffixes = %w(ALLEY ANNEX ARCADE AVENUE BAYOO BEACH BEND BLUFF BLUFFS BOTTOM BOULEVARD BRANCH BRIDGE BROOK BROOKS BURG BURGS BYPASS CAMP CANYON CAPE CAUSEWAY CENTER CENTERS CIRCLE CIRCLES CLIFF CLIFFS CLUB COMMON CORNER CORNERS COURSE COURT COURTS COVE COVES CREEK CRESCENT CREST CROSSING CROSSROAD CURVE DALE DAM DIVIDE DRIVE DRIVES ESTATE ESTATES EXPRESSWAY EXTENSION EXTENSIONS FALL FALLS FERRY FIELD FIELDS FLAT FLATS FORD FORDS FOREST FORGE FORGES FORK FORKS FORT FREEWAY GARDEN GARDENS GATEWAY GLEN GLENS GREEN GREENS GROVE GROVES HARBOR HARBORS HAVEN HEIGHTS HIGHWAY HILL HILLS HOLLOW INLET ISLAND ISLANDS ISLE JUNCTION JUNCTIONS KEY KEYS KNOLL KNOLLS LAKE LAKES LAND LANDING LANE LIGHT LIGHTS LOAF LOCK LOCKS LODGE LOOP MALL MANOR MANORS MEADOW MEADOWS MEWS MILL MILLS MISSION MOTORWAY MOUNT MOUNTAIN MOUNTAINS NECK ORCHARD OVAL OVERPASS PARK PARKS PARKWAY PARKWAYS PASS PASSAGE PATH PIKE PINE PINES PLACE PLAIN PLAINS PLAZA POINT POINTS PORT PORTS PRAIRIE RADIAL RAMP RANCH RAPID RAPIDS REST RIDGE RIDGES RIVER ROAD ROADS ROUTE ROW RUE RUN SHOAL SHOALS SHORE SHORES SKYWAY SPRING SPRINGS SPUR SPURS SQUARE SQUARES STATION STRAVENUE STREAM STREET STREETS SUMMIT TERRACE THROUGHWAY TRACE TRACK TRAFFICWAY TRAIL TUNNEL TURNPIKE UNDERPASS UNION UNIONS VALLEY VALLEYS VIADUCT VIEW VIEWS VILLAGE VILLAGES VILLE VISTA WALK WALKS WALL WAY WAYS WELL WELLS ALLEE ALLY ALY ANEX ANNX ANX ARC AV AVE AVEN AVENU AVN AVNUE BAYOU BCH BND BLF BLUF BOT BOTTM BTM BLVD BOUL BOULV BR BRNCH BRDGE BRG BRK BYP BYPA BYPAS BYPS CMP CP CANYN CNYN CYN CPE CAUSWAY CSWY CEN CENT CENTR CENTRE CNTER CNTR CTR CIR CIRC CIRCL CRCL CRCLE CLF CLFS CLB COR CORS CRSE CRT CT CTS CV CK CR CRK CRECENT CRES CRESENT CRSCNT CRSENT CRSNT CRSSING CRSSNG XING DL DM DIV DV DVD DR DRIV DRV EST ESTS EXP EXPR EXPRESS EXPW EXPY EXT EXTN EXTNSN EXTS FLS FRRY FRY FLD FLDS FLT FLTS FRD FORESTS FRST FORG FRG FRK FRKS FRT FT FREEWY FRWAY FRWY FWY GARDN GDN GRDEN GRDN GDNS GRDNS GATEWY GATWAY GTWAY GTWY GLN GRN GROV GRV HARB HARBR HBR HRBOR HAVN HVN HEIGHT HGTS HT HTS HIGHWY HIWAY HIWY HWAY HWY HL HLS HLLW HOLLOWS HOLW HOLWS INLT IS ISLND ISLNDS ISS ISLES JCT JCTION JCTN JUNCTN JUNCTON JCTNS JCTS KY KYS KNL KNOL KNLS LK LKS LNDG LNDNG LA LANES LN LGT LF LCK LCKS LDG LDGE LODG LOOPS MNR MNRS MDW MDWS MEDOWS ML MLS MISSN MSN MSSN MNT MT MNTAIN MNTN MOUNTIN MTIN MTN MNTNS NCK ORCH ORCHRD OVL PK PRK PARKWY PKWAY PKWY PKY PKWYS PATHS PIKES PNES PL PLN PLAINES PLNS PLZ PLZA PT PTS PRT PRTS PR PRARIE PRR RAD RADIEL RADL RANCHES RNCH RNCHS RPD RPDS RST RDG RDGE RDGS RIV RIVR RVR RD RDS SHL SHLS SHOAR SHR SHOARS SHRS SPG SPNG SPRNG SPGS SPNGS SPRNGS SQ SQR SQRE SQU SQRS STA STATN STN STRA STRAV STRAVE STRAVEN STRAVN STRVN STRVNUE STREME STRM ST STR STRT SMT SUMIT SUMITT TER TERR TRACES TRCE TRACKS TRAK TRK TRKS TRFY TR TRAILS TRL TRLS TUNEL TUNL TUNLS TUNNELS TUNNL TPK TPKE TRNPK TRPK TURNPK UN VALLY VLLY VLY VLYS VDCT VIA VIADCT VW VWS VILL VILLAG VILLG VILLIAGE VLG VLGS VL VIS VIST VST VSTA WY WLS BYU BLFS BRKS BG BGS CTRS CIRS CMN CVS CRST XRD CURV DRS FRDS FRGS GLNS GRNS GRVS HBRS LGTS MTWY MTNS OPAS PSGE PNE RTE SKWY SQS STS TRWY UPAS UNS WL)
	Directions = %w(N NE E SE S SW W NW)

end
