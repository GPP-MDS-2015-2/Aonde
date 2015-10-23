class FunctionController < ApplicationController

	def show

		insert_expenses_functions

	end

	def insert_expenses_functions

		function = Function.new
		expenses = function.get_expenses_by_function
		convert_to_a_hash(expenses)
			
	end

	def convert_to_a_hash(expenses)

		@expense_hash = JSON.parse(expenses)

	end

end	