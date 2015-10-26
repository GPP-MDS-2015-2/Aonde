class FunctionController < ApplicationController

	def show
	
		datas = insert_expenses_functions(2015,2015,1,12)
		@correct_datas = datas.to_json

	end

	def filter

		datas = control_datas(params[:year],params[:month])
		@correct_datas = datas.to_json
		render 'show'

	end

	def control_datas(year = "Todos",month = "Todos")

		if year == "Todos"
			insert_expenses_functions(2010,2015,1,12)
		elsif year == "Até hoje!"
			insert_expenses_functions(2010,2015,1,12)
		else	
			if month == "Todos"
				insert_expenses_functions(2010,2015,1,12)
			else
				insert_expenses_functions(year.to_i,year.to_i,month_to_int(month),month_to_int(month))
			end
		end

	end

	def insert_expenses_functions(yeari,yearf,monthi,monthf)

		expenses = get_expenses_by_function(yeari,yearf,monthi,monthf)
		expense_hash = convert_to_a_hash(expenses)
		correct_datas = filter_datas_in_expense(expense_hash)
		
	end

	def get_expenses_by_function(first_year,last_year,first_month,last_month)

		start = Date.new(2015,first_month,1)
		end_of = Date.new(2015,last_month,31)

  		Function.joins(:expense).where("DATE(payment_date) BETWEEN ? AND ?", start, end_of).select("YEAR(payment_date) as date_test,sum(expenses.value) as sumValue,functions.description").group("YEAR(payment_date),functions.description").to_json

	end

	

	def convert_to_a_hash(expenses)

		expense_hash = JSON.parse(expenses)
		
	end

	def filter_datas_in_expense(expense_hash)

  		correct_hash = {}
  		expense_hash.each do |hash|
    		correct_hash[hash["description"]] = hash["sumValue"]    
  		end
  		return correct_hash

	end

end	