class TypeExpenseController < ApplicationController
	def show
		@public_agency = PublicAgency.find(params[:id])
		@data_type_expense = get_expense_by_type(@public_agency.id)
		#sleep(2)
	end

	def get_expense_by_type(id_public_agency)
			list_type_expenses = []			
			types_expense = TypeExpense.all
			types_expense.each do |type|
				total_expense_by_type = find_exepenses(id_public_agency,type.id)
				dictionary_expense = create_dictionary(total_expense_by_type,type)
				if not dictionary_expense.empty?
					list_type_expenses << dictionary_expense
				else
					# Do nothing
				end
			end
			return list_type_expenses.to_json
	end

	def create_dictionary(value_expense, type_expense)
		expense_dictionary = {}
		if value_expense != 0
			expense_dictionary = {name: type_expense.description,value: value_expense,colorValue: 10}
		else
			# Do nothing
		end
		return expense_dictionary
	end

	def find_exepenses(id_public_agency = 0, id_type_expense = 0)
 		expense_value = Expense.where(public_agency_id: id_public_agency,
			 							   type_expense_id: id_type_expense).sum(:value)
 		return expense_value
	end
end