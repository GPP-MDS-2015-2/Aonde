class Function < ActiveRecord::Base

	has_many :expense

	def get_expenses_by_function(year = 2015,month = 1)

		start = Date.new(year,1,1)
		end_of = Date.new(year,12,28)

  		Function.joins(:expense).where("DATE(payment_date) BETWEEN ? AND ?", start, end_of).select("YEAR(payment_date) as date_test,sum(expenses.value) as sumValue,functions.description").group("YEAR(payment_date),functions.description").to_json

	end

end
