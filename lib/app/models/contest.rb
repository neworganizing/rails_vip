class Contest < ActiveRecord::Base
	set_inheritance_column :ruby_type
	belongs_to :source
	belongs_to :tabulation_area
	belongs_to :ballot
	belongs_to :election
	has_many :custom_notes, :as => :object
end
