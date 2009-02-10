class Election < ActiveRecord::Base
	belongs_to :source
	belongs_to :state
	
end
