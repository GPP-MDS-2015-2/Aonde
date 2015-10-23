class Expense < ActiveRecord::Base
  belongs_to :program 
  belongs_to :public_agency
  validates :document_number,on: :create,presence: true
  validates :payment_date, presence: true,on: :create
end
