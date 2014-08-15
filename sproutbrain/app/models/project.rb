class Project < ActiveRecord::Base

	belongs_to :owner, class_name: "User", foreign_key: "user_id"
	# belongs_to :user
	#, class_name: "User", foreign_key: "user_id"

	#has_many :events, dependent: :destroy

	has_many :cycles, dependent: :destroy
	has_many :participants, dependent: :destroy

end
