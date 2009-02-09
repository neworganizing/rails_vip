class ElectionAdministration < ActiveRecord::Base
	belongs_to :source
	has_one :eo, :class_name => 'ElectionOfficial'
	has_one :ovc, :class_name => 'ElectionOfficial'
end
