class Contest < ActiveRecord::Base
	belongs_to :source
	belongs_to :tabulation_area
	belongs_to :ballot
end
