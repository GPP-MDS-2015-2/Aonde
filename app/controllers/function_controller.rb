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
			insert_expenses_functions(2010,2015,1,12,1,31)
		elsif year == "Até hoje!"
			insert_expenses_functions(2010,2015,1,12,1,31)
		else	
			if month == "Todos"
				insert_expenses_functions(year.to_i,year.to_i,1,12,1,31)
			else
				day_final = find_month_limit(month_to_int(month))
				day_init = 1
				insert_expenses_functions(year.to_i,year.to_i,month_to_int(month),month_to_int(month),day_init,day_final)
			end
		end

	end

	def insert_expenses_functions(year_init,year_final,month_init,month_final,day_init,day_final)

		@function = Function.new
		expenses = @function.get_expenses_by_function(year_init,year_final,month_init,month_final,day_init,day_final)
		expense_hash = convert_to_a_hash(expenses)
		correct_datas = filter_datas_in_expense(expense_hash)
		
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

	def find_month_limit(month)
		if month == 1 or  month == 3 or month == 5 or month ==  7 or month == 8 or  month == 10 or month == 12
			return 31
		elsif month == 4 or  month == 6 or month == 9 or month == 11
			return 30
		elsif month == 2
			return 28 
		end
	end

end	