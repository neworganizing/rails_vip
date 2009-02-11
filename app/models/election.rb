class Election < ActiveRecord::Base
	belongs_to :source
	belongs_to :state
	has_and_belongs_to_many :contests
end
