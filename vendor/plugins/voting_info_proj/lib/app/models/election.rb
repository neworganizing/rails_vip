class Election < ActiveRecord::Base
	belongs_to :source
	belongs_to :state
	has_many :contests
	has_many :custom_notes, :as => :object
end
