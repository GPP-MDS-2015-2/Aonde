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

  	def get_list_expenses_by_period(id_public_agency,month_init,year_init,month_final,year_final)
  		#create a hash to convert a name of month to int
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
		@total_expense = 0

		#create a new hash to put the values
		new_total_expense_per_date = {}
		#take all of expenses
		expenses = Expense.where(program_id: Program.where(public_agency_id: id_public_agency).ids)
      	if(valide_date(year_init,year_final,month_init,month_final))
	      	expenses.each do |exp|
				date = exp.payment_date
				#see if the date are in the hash and add in the new	
				#verifyy if the date are in the interval
				if date.year.to_i >= year_init.to_i && date.year.to_i <= year_final.to_i
			  		if date.month.to_i >= conversion_data[month_init] && date.month.to_i <= conversion_data[month_final]
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
	  	#return the hash with expenses like a array
	  	return new_total_expense_per_date.sort_by { |date, expenses| Date.parse(date) }.to_a
	end
	def valide_date(ano_inicio,ano_fim,mes_inicio,mes_fim)
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
		if(ano_inicio == ano_fim)
			if(conversion_data[mes_inicio] > conversion_data[mes_fim])
				return false
			end
		elsif (ano_inicio > ano_fim)
			return false
		end
		return true
	end
end
