class Program < ActiveRecord::Base
  belongs_to :public_agency
  
  has_many :expense
  has_one :function
  has_one :type_expense
  has_one :company

  validates :name, presence: true
end
