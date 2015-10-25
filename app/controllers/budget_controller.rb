class BudgetController < ApplicationController
#Eduardo
	def show
  		find_public_agency
  		@list_expense_month = get_list_expenses_by_period(@public_agency.id)
  		@list_expense_month.to_json
  		@expense_find = 1
  	end
#Segunda - both 
  	def get_list_expenses_by_period(id_public_agency,first_month="Janeiro",first_year=0000,last_month="Dezembro",last_year=9999)

		@total_expense = 0		
		new_total_expense_per_date = {}

		temporary_expenses_agency = get_expenses_agency(id_public_agency)

		temporary_expenses_agency.each do |date,value|
		#see if the date are in the hash and add in the new
			if is_date_in_interval(first_month,first_year,last_month,last_year, date)
	        	if new_total_expense_per_date[date.year] == nil
	        		new_total_expense_per_date[date.year] = initialize_hash(date.year)
	        	end	        	
        		new_total_expense_per_date [date.year][l(date)] = value
        		@total_expense += value
		  	end
		end
	  	#return the hash with expenses like a array
	  	expense_by_month = transform_hash_to_array(new_total_expense_per_date)
	  	expense_by_month.sort_by! {|expense_month| Date.parse(expense_month[0])}

	  	return expense_by_month
	end
#Busche
	def transform_hash_to_array(expense_by_year)
		hash_to_array = []	
		expense_by_year.each do |year, expenses|
			expense_month_year = expenses.to_a
			hash_to_array.concat(expense_month_year)
		end
		return hash_to_array
	end
#Eduardo
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
#Done
  	def is_date_in_interval(first_month,first_year,last_month,last_year, date)

			if date.year.to_i >= first_year.to_i && date.year.to_i <= last_year.to_i
				if date.month.to_i >= month_to_int(first_month) && date.month.to_i <= month_to_int(last_month)
					return true
				else
					return false
		   		end
		   	else
		   		return false
			end		
	end
#Eduardo
  	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])
		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
	end
#Done
	def initialize_hash(year)
		expenses_months = {}
		for month in 1..12
			date = Date.new(year,month, 1);
			expenses_months[l(date)]= 0
		end
		return expenses_months
	end
#Done
	def filter_chart_budget

		find_public_agency
		@list_expense_month = get_list_expenses_by_period(@public_agency.id, "Janeiro", params[:year], "Dezembro", params[:year]);
		@expense_find = 0
		if not is_empty_filter(@list_expense_month)
			@expense_find = 1
			# Nothing to do
		else
			@list_expense_month = get_list_expenses_by_period(@public_agency.id)
		end
		@list_expense_month = @list_expense_month.to_json

		render 'show'

	end
#Done
	def is_empty_filter(list_expenses = [])
		
		empty_filter = list_expenses.empty?
		
		if not empty_filter
			# Do nothing
		else
			flash[:error] = "Nenhuma despesa encontrada no periodo desejado! Veja o gráfico total:"
		end
		return empty_filter
	end
end