class FunctionController < ApplicationController

	def show
	
		@correct_datas = insert_expenses_functions

	end

	def insert_expenses_functions

		function = Function.new
		expenses = function.get_expenses_by_function
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

end	