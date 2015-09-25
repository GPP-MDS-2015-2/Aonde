class PublicAgencyController < ApplicationController
	#list of all public agencies in DB
	def index
		@public_agencies = PublicAgency.all
	end

	#Find the data of one public agency to show in the view with chart
	def show
		@public_agency = PublicAgency.find(params[:id])
		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
		@list_expense_month = get_list_expense_month(params[:id])
		@list_expense_month.unshift(["Data","gasto"])
	end


	#Calculate by month/year the total of expense
	def get_list_expense_month(id_public_agency)
	  	total_expense_per_date = {}
	  	programs = Program.where(public_agency_id: id_public_agency)
	  	programs.each do |prog|
	  		expenses = Expense.where(program_id: prog.id)
	  		expenses.each do |exp|
	  			date = l(Date.new(exp.payment_date.year,exp.payment_date.month,1))
	  			if total_expense_per_date [date] == nil
	  				total_expense_per_date [date] = 0
	  			end
	  			total_expense_per_date [date] += exp.value
	  		end	
	  	end
	  	return total_expense_per_date.sort_by { |date, expenses| date }.to_a
	end

end
