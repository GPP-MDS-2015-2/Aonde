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
		increment_views_amount
	end

	#Calculate by month/year the total of expense
	
  	def get_list_expenses_by_period(id_public_agency,month_init,year_init,month_final,year_month)
	
		total_expense_per_date = list_expense_month(id_public_agency)
		total_expense_per_date.each do |date,valor|
			if date.year.to_i >= year_init && date.year.to_i <= year_final
		  		if date.month.to_i >= month_init && date.month.to_i <= month_final
		  			total_expense_per_date [date] += exp.value
		  		end
		  	end
		end
	  	return total_expense_per_date_by_period.to_a	  	
	end
	

	def increment_views_amount	
		views_amount = @public_agency.views_amount
		views_amount += 1
		@public_agency.update(views_amount: views_amount)		
	end


	def get_list_expense_month(id_public_agency)
    total_expense_per_date = {}
    #Takes all programs and return a list
      expenses = Expense.where(program_id: Program.where(public_agency_id: id_public_agency).ids)
      expenses.each do |exp|
        date = l(Date.new(exp.payment_date.year,exp.payment_date.month,1))
        if total_expense_per_date [date] == nil
          total_expense_per_date [date] = 0
        end
        total_expense_per_date [date] += exp.value
      end 
    return total_expense_per_date.sort_by { |date, expenses| Date.parse(date) }.to_a
  end


end
