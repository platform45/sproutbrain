class Seedtag < ActiveRecord::Base

	# connects cycles with seeds
	belongs_to :seed
	belongs_to :cycle, polymorphic: true, dependent: :destroy

end