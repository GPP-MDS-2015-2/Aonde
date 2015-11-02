class Program < ActiveRecord::Base

  has_many :expense
  has_one :type_expense
  has_one :company

  validates :name, presence: true
end
