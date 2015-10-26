class Function < ActiveRecord::Base

	has_many :expense

	def get_expenses_by_function(first_year,last_year,first_month,last_month,first_day,last_day)

		start = Date.new(first_year,first_month,first_day)
		end_of = Date.new(last_year,last_month,last_day)

  		Function.joins(:expense).where("DATE(payment_date) BETWEEN ? AND ?", start, end_of).select("YEAR(payment_date) as date_test,sum(expenses.value) as sumValue,functions.description").group("YEAR(payment_date),functions.description").to_json

	end

end
