class BudgetController < ApplicationController
	#list of all public agencies in DB
	def index
		@public_agencies = PublicAgency.all
		@total_expense_agency = {}
		@public_agencies.each do |agency|
			@total_expense_agency[agency.id] = expenses_public_agency(agency.id)
		end
	end

  	def show
  		find_public_agency
  		@list_expense_month = get_list_expenses_by_period(@public_agency.id)
  		@list_expense_month.to_json
  	end
  	def get_list_expenses_by_period(id_public_agency,first_month="Janeiro",first_year=0000,last_month="Dezembro",last_year=9999)

		@total_expense = 0		
		new_total_expense_per_date = {}

		temporary_expenses_agency = get_expenses_agency(id_public_agency)

		temporary_expenses_agency.each do |date,value|
		#see if the date are in the hash and add in the new
			if is_date_in_interval(first_month,first_year,last_month,last_year, date)
	        	new_total_expense_per_date [l(date)] = value
	        	@total_expense += value
		  	end
		end
	  	#return the hash with expenses like a array
	  	return new_total_expense_per_date.sort_by { |date, expenses| Date.parse(date) }.to_a
	end

	def get_expenses_agency(id_public_agency)
    	total_expense_per_date = {}
    	#Takes all programs and return a list
    	#@total_expense = 0
    	expenses = Expense.where(public_agency_id: id_public_agency)
    	expenses.each do |exp|
        	date = Date.new(exp.payment_date.year,exp.payment_date.month,1)
        	if total_expense_per_date [date] == nil
          		total_expense_per_date [date] = 0
        	end
        	total_expense_per_date [date] += exp.value
#        	@total_expense += exp.value
      	end 
    	return total_expense_per_date
  	end	

  	def is_date_in_interval(first_month,first_year,last_month,last_year, date)

			if date.year.to_i >= first_year.to_i && date.year.to_i <= last_year.to_i
				if date.month.to_i >= month_to_int(first_month) && date.month.to_i <= month_to_int(last_month)
					return true
				else
					return false
		   		end
			end		
	end

  	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])
		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
	end
end