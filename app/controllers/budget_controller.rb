# Controller of budget to manage the data of expenses and budget
class BudgetController < ApplicationController

	def show
		puts params
		if !params[:year]
			params[:year]=2015
		end
		# Process the expense
        expense_month = HelperController.expenses_year(params[:id].to_i,
        												params[:year])
        expense_month = initialize_hash(params[:year],expense_month)
        expense_month = HelperController.int_to_month(expense_month).to_a

        # Process the budget
    	budget_month = []
      begin
       	budget_month = subtract_expenses_on_budget(params[:id], params[:year],
       											  expense_month)        
      rescue Exception => error
        logger.error "#{error}"
      end
      dataBudget = {'expenses'=> expense_month,'budgets'=>budget_month}
      puts dataBudget
      respond_to do |format|
		format.json {render json: dataBudget}
      end
  	end

	def initialize_hash(year,expense_month)
		expenses_months = {}
		for month in 1..12
			if !expense_month[month]
				expenses_months[month]= 0
			else
				expenses_months[month]=expense_month[month]
			end
		end
		return expenses_months
	end

	def subtract_expenses_on_budget(id_public_agency,year,expense)
		
		budget_array = []
	    begin
	     	budgets = BudgetAPI.get_budget(id_public_agency, year)
	     	if !expense.empty?
  				budget_array = create_budget_array(expense ,budgets, year)
  				puts "#{budget_array}"
  			end
	    rescue Exception => error
	    	raise "Não foi possível obter o orçamento do ano #{year} do Órgão Público desejado\n#{error}"
		end
    	return budget_array
	end
	
    def create_budget_array(expenses, budgets, year)
		budget_array = []
		budget = budgets[0]
		if (budget['year']+1) == year.to_i
			for i in 0..11
				value = expenses[i][1]
				budget["value"] -= value
				budget_array << budget['value']
			end
		end

		return budget_array
	end 
end