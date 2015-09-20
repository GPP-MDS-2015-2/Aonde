class Expense < ActiveRecord::Base
  belongs_to :program 
  validates :document_number, uniqueness: true,on: :create,presence: true
  validates :payment_date, presence: true,uniqueness: true,on: :create
end
