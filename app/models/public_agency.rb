class PublicAgency < ActiveRecord::Base
  belongs_to :superior_public_agency
  has_many :expense

#including validation.
  validates :name, presence: true
  validates :views_amount, numericality: {greater_than: -1}

end
