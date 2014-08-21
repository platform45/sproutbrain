class Project < ActiveRecord::Base

	belongs_to :owner, class_name: "User", foreign_key: "user_id"

	has_many :cycles, dependent: :destroy
	has_many :participants, dependent: :destroy

end
