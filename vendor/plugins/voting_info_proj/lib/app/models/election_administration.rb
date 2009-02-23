class ElectionAdministration < ActiveRecord::Base
	belongs_to :source
	belongs_to :eo, :class_name => 'ElectionOfficial'
	belongs_to :ovc, :class_name => 'ElectionOfficial'
	has_many :custom_notes, :as => :object
end
