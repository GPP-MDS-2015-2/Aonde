class TypeExpense < ActiveRecord::Base
	belongs_to :expense
	validates :description, presence: true
end
