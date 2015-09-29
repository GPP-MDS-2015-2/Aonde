class PublicAgencyController < ApplicationController
	#list of all public agencies in DB
	def index
		@public_agencies = PublicAgency.all
	end

	#Find the data of one public agency to show in the view with chart
	def show
		@public_agency = PublicAgency.find(params[:id])
		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
		@list_expense_month = get_list_expense_month(params[:id]).to_a
		@list_expense_month.unshift(["Data","gasto"])
		increment_views_amount
	end

	#Calculate by month/year the total of expense

	def increment_views_amount	
		views_amount = @public_agency.views_amount
		views_amount += 1
		@public_agency.update(views_amount: views_amount)		
	end


	def get_list_expense_month(id_public_agency)
    total_expense_per_date = {}
    #Takes all programs and return a list
    @total_expense = 0
      expenses = Expense.where(program_id: Program.where(public_agency_id: id_public_agency).ids)
      expenses.each do |exp|
        date = l(Date.new(exp.payment_date.year,exp.payment_date.month,1))
        if total_expense_per_date [date] == nil
          total_expense_per_date [date] = 0
        end
        total_expense_per_date [date] += exp.value
        @total_expense += exp.value
      end 
    return total_expense_per_date.sort_by { |date, expenses| Date.parse(date) }.to_a
  end

def filter_chart
  		#find the same thing then the show
  		@public_agency = PublicAgency.find(params[:id])
  		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
  		#create the new list with filters apllied
  		@list_expense_month = get_list_expenses_by_period(@public_agency.id,params[:from_months],params[:from_year],params[:ends_in_the_months],params[:ends_in_the_year])
  		#insert the head in the list
  		@list_expense_month.unshift(["Data","Gasto"])
		render 'show'
  	end

	#create a hash to convert a name of month to int
  	def month_to_int(month)
	
		conversion_data = {}
		conversion_data['Janeiro'] = 1
		conversion_data['Fevereiro'] = 2
		conversion_data['Março'] = 3
		conversion_data['Abril'] = 4
		conversion_data['Maio'] = 5
		conversion_data['Junho'] =6
		conversion_data['Julho'] = 7
		conversion_data['Agosto'] = 8
		conversion_data['Setembro'] = 9
		conversion_data['Outubro'] = 10
		conversion_data['Novembro'] = 11
		conversion_data['Dezembro'] = 12

		return conversion_data[month]
	end

  	def get_list_expenses_by_period(id_public_agency,first_month,first_year,last_month,last_year)

		@total_expense = 0

		#create a new hash to put the values
		new_total_expense_per_date = {}
		#take all of expenses
		expenses = Expense.where(program_id: Program.where(public_agency_id: id_public_agency).ids)
      	if(valide_date(first_year,last_year,first_month,last_month))
	      	expenses.each do |exp|
				date = exp.payment_date
				#see if the date are in the hash and add in the new	
				#verifyy if the date are in the interval
				if date.year.to_i >= first_year.to_i && date.year.to_i <= last_year.to_i
			  		if date.month.to_i >= month_to_int(first_month) && date.month.to_i <= month_to_int(last_month)
		        		date = l(Date.new(exp.payment_date.year,exp.payment_date.month,1))
		        		if(new_total_expense_per_date[date] == nil)
		        			new_total_expense_per_date [date] = 0
		        		end
		        		new_total_expense_per_date [date] += exp.value
		        		@total_expense += exp.value
			  		end
			  	end
			end
		else
			return get_list_expense_month(id_public_agency)
		end

		#This is just to prevent the error if don't have a expense
	  	if @total_expense == 0
	  		return new_total_expense_per_date = {"":0}.to_a
	  	end
	  	

	  	#return the hash with expenses like a array
	  	return new_total_expense_per_date.sort_by { |date, expenses| Date.parse(date) }.to_a
	end
	def valide_date(first_year,last_year,first_month,last_month)

		if(first_year == last_year)
			if(month_to_int(first_month) > month_to_int(last_month))
				return false
			end
		elsif (first_year > last_year)
			return false
		end
		return true

	end
	
end
