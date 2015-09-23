class PublicAgencyController < ApplicationController

	def index

		@public_agencies = PublicAgency.all

		@public_agency_grid = initialize_grid(PublicAgency,
			order: 'public_agencies.views_amount',
      		order_direction: 'desc',
      		per_page: 10
        )

	end

	def show

		@public_agency = PublicAgency.find(params[:id])
		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
		@list_expense_month = get_list_expense_month(params[:id])

	end

	def get_list_expense_month(id_public_agency)
	  	total_expense_per_date = [["ano","gasto"]]
	  	programs = Program.where(public_agency_id: id_public_agency)
	  	programs.each do |prog|
	  		expenses = Expense.where(program_id: prog.id)
	  		expenses.each do |exp|
	  			month = Date::MONTHNAMES[exp.payment_date.month]
	  			year = exp.payment_date.year
	  			expense_info = ["#{month}/#{year}",exp.value] 
	  			total_expense_per_date << expense_info
	  		end	
	  	end
	  	return total_expense_per_date
	end

end
