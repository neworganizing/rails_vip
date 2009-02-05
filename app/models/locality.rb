class Locality < ActiveRecord::Base
	set_inheritance_column :ruby_type

	belongs_to :source
	belongs_to :election_administration

end
