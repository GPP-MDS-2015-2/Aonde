class PublicAgencyController < ApplicationController
	#list of all public agencies in DB
	def index
		@public_agencies = PublicAgency.search(params[:search])
		@total_expense_agency = {}
		@public_agencies.each do |agency|
			@total_expense_agency[agency.id] = expenses_public_agency(agency.id)
		end
	end

	#Find the data of one public agency to show in the view with chart
	def show
		find_agencies(params[:id])
		increment_views_amount
		@list_expense_month = get_list_expenses_by_period(@public_agency.id)
		@list_expense_month.unshift(["Data","gasto"])		
	end

	

	def expenses_public_agency(id_pub_agency)
	  	total_expense = Expense.where(public_agency_id: id_pub_agency).sum(:value)
	  	return total_expense
	end

	def filter_chart 
  		#find the same thing then the show
  		find_agencies(params[:id])
  		#create the new list with filters apllied
  		@true_total_expense = 0
  		message_invalid_input(params[:from_year],params[:ends_in_the_year],params[:from_months],
			params[:ends_in_the_months])
  		
		if is_date_valid(params[:from_year],params[:ends_in_the_year],params[:from_months],
			params[:ends_in_the_months])	
  			@list_expense_month = get_list_expenses_by_period(@public_agency.id,params[:from_months],params[:from_year],
  				params[:ends_in_the_months],params[:ends_in_the_year])
  			@true_total_expense = @total_expense
  		else
  			@true_total_expense = @total_expense
  			@list_expense_month = get_list_expenses_by_period(@public_agency.id)
  		end
  		
  		if @total_expense == 0
  			@true_total_expense = @total_expense
  			flash[:error] = "Não encontrou nenhum gasto neste periodo, grafico de gastos total:"
  			@list_expense_month = get_list_expenses_by_period(@public_agency.id)
  		end
  		#insert the head in the list
		@list_expense_month.unshift(["Data","Gasto"])
		render 'show'
  	end

	#Calculate by month/year the total of expense
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

	def increment_views_amount	
		views_amount = @public_agency.views_amount
		views_amount += 1
		@public_agency.update(views_amount: views_amount)		
	end


	def message_invalid_input(first_year,last_year,first_month,last_month)
		
		if is_date_valid(first_year,last_year,first_month,last_month) == false
			flash[:error] = "Intervalo de tempo invalido, grafico de gastos total:"
		end
	end
	def is_date_valid(first_year,last_year,first_month,last_month)

		if first_year == nil or last_year == nil or first_month.empty? or last_month.empty?
#			flash[:error] = "Intervalo de tempo invalido, grafico de gastos total:1"
			return false
		else
			
		end
		if(first_year == last_year)
			if(month_to_int(first_month) > month_to_int(last_month))
#				flash[:error] = "Intervalo de tempo invalido, grafico de gastos total:2"
				return false
			end
		elsif (first_year > last_year)
#			flash[:error] = "Intervalo de tempo invalido, grafico de gastos total:3"
			return false
		end
		return true
	end

	#verify if the date are in the interval
	def is_date_in_interval(first_month,first_year,last_month,last_year, date)

			if date.year.to_i >= first_year.to_i && date.year.to_i <= last_year.to_i
				if date.month.to_i >= month_to_int(first_month) && date.month.to_i <= month_to_int(last_month)
					return true
				else
					return false
		   		end
			end		
	end
	
	#methods that's need to be private
	private :increment_views_amount, :month_to_int, :is_date_valid
	#private :increment_views_amount, :month_to_int
end