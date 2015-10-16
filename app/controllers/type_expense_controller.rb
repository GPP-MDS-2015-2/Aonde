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
				total_expense_by_type = Expense.where(public_agency_id: id_public_agency,
			 							   type_expense_id: id_type_expense).sum(:value)
				list_type_expenses <<{type.description:total_expense_by_type}
			end
			return list_type_expenses.to_json
	end
end