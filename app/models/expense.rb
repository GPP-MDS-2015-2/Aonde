class Expense < ActiveRecord::Base
  belongs_to :program 
  belongs_to :public_agency
  validates :document_number, uniqueness: true,on: :create,presence: true
  validates :payment_date, presence: true,on: :create
  has_one :function
end
