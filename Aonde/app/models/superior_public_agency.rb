class SuperiorPublicAgency < ActiveRecord::Base
	has_many :public_agencies 

	validates :name, presence: true
end
