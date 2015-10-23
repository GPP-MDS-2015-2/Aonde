class Function < ActiveRecord::Base

	has_many :expense

	def get_expenses_by_function

  		Function.joins(:expense).select("sum(expenses.value) as sumValue,functions.description").group("functions.description").to_json

	end

end
