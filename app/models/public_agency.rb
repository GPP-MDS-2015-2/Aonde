class PublicAgency < ActiveRecord::Base
  belongs_to :superior_public_agency
  has_many :expenses
  has_many :budgets

#including validation.
  validates :name, presence: true
  validates :views_amount, numericality: {greater_than: -1}
	
	def self.search(search)
  	if search
  		where("name LIKE ?","%#{search}%")
  	else
  		all
  	end 	
  end
  
end
