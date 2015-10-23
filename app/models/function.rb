class Function < ActiveRecord::Base

	def get_expenses_by_function

  		Expense.select("sum(value) as sumValue,function_id").group("function_id").to_json

	end

end
