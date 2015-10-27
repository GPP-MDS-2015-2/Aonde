class BudgetController < ApplicationController

	def show
  		find_public_agency
  		@list_budget_month = subtract_expenses_on_budget(@public_agency.id, 2015)
  		@list_expense_month = get_list_expenses_by_period(@public_agency.id, "Janeiro", 2015, "Dezembro", 2015)
  		@list_expense_month.to_json
  		@list_budget_month.to_json
  		@expense_find = 1
  	end

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

	def transform_hash_to_array(expense_by_year)
		hash_to_array = []	
		expense_by_year.each do |year, expenses|
			expense_month_year = expenses.to_a
			hash_to_array.concat(expense_month_year)
		end
		#puts "#{hash_to_array}"
		return hash_to_array
	end

	def get_expenses_agency(id_public_agency)
    	total_expense_per_date = {}
    	#Takes all programs and return a list
    	expenses = Expense.where(public_agency_id: id_public_agency)
    	expenses.each do |exp|
        	date = Date.new(exp.payment_date.year,exp.payment_date.month,1)
        	if total_expense_per_date [date] == nil
          		total_expense_per_date [date] = 0
        	end
        	total_expense_per_date [date] += exp.value
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
		   	else
		   		return false
			end		
	end

  	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])
		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
	end

	def initialize_hash(year)
		expenses_months = {}
		for month in 1..12
			date = Date.new(year,month, 1);
			expenses_months[l(date)]= 0
		end
		return expenses_months
	end

	def filter_chart_budget

		find_public_agency
		@list_budget_month = subtract_expenses_on_budget(@public_agency.id, params[:year]);
		@list_expense_month = get_list_expenses_by_period(@public_agency.id, "Janeiro", params[:year], "Dezembro", params[:year]);
		@expense_find = 0
		if not is_empty_filter(@list_expense_month)
			@expense_find = 1
			# Nothing to do
		else
			@list_expense_month = get_list_expenses_by_period(@public_agency.id)
		end
		@list_expense_month = @list_expense_month.to_json
		@list_budget_month = @list_budget_month.to_json

		render 'show'

	end

	def is_empty_filter(list_expenses = [])
		
		empty_filter = list_expenses.empty?
		
		if not empty_filter
			# Do nothing
		else
			flash[:error] = "Nenhuma despesa encontrada no periodo desejado! Veja o gráfico total:"
		end
		return empty_filter
	end

	def subtract_expenses_on_budget(id_public_agency,year)
		expense = get_list_expenses_by_period(id_public_agency, "Janeiro", year, "Dezembro", year)
		budgets = [{'year'=>2015,'value'=>5252923}]
		budget_array = create_budget_array(expense ,budgets, year)
		return budget_array
	end
	def create_budget_array(expenses, budgets, year)
		budget_array = []
		budget = budgets[0]
		if budget['year'] == year
			for i in 0..11	
				value = expenses[i][1]
				budget["value"] -= value
				budget_array << budget['value']
			end
		end
	
		return budget_array
	end

end