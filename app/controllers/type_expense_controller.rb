class TypeExpenseController < ApplicationController
	def show

		find_agencies(params[:id])
		@data_type_expense = get_expense_by_type(@public_agency.id).to_json
		@expense_type_find = 1

	end

	def filter_chart
	
		find_agencies(params[:id])
		@data_type_expense = get_expense_by_type(@public_agency.id,params[:year],params[:month])

		#puts "#{@data_type_expense.empty?} #{params[:year]} #{params[:month]}"
		
		@expense_type_find = 0
		if not @data_type_expense.empty?
			@expense_type_find = 1 
			# no mensage!
		else
			flash[:error] = "Nenhuma despesa encontrada no periodo desejado! Veja o gráfico total:"
			@data_type_expense = get_expense_by_type(@public_agency.id)			
		end

		@data_type_expense = @data_type_expense.to_json

		render 'show'

	end
	
	def get_expense_by_type(id_public_agency, year = "Todos", month = "Todos")
		list_type_expenses = []			
		types_expense = TypeExpense.all
		total_expense = 0
		types_expense.each do |type|
			total_expense_by_type = find_exepenses(id_public_agency,type.id,year,month)
			dictionary_expense = create_dictionary(total_expense_by_type,type)
			if not dictionary_expense.empty?
				total_expense += total_expense_by_type
				list_type_expenses << dictionary_expense
			else
				# Do nothing
			end
		end
		define_color(total_expense,list_type_expenses)
		return list_type_expenses
	end

	def create_dictionary(value_expense, type_expense)
		expense_dictionary = {}
		if value_expense != 0 
			expense_dictionary = {name: type_expense.description,value: value_expense,colorValue: 10}
		else
			# Do nothing
		end
		return expense_dictionary
	end

	def find_exepenses(id_public_agency = 0, id_type_expense = 0,year = "Todos",month="Todos")
 		expenses_find = Expense.where(public_agency_id: id_public_agency,
			 							   type_expense_id: id_type_expense)
 		expense_value = 0
 		expenses_find.each do |expense|
 			#puts "#{year} #{month} == #{"Todos"} #{"Todos" == month} #{expense.payment_date} "
 			if is_date_select(year,month,expense)

 				expense_value += expense.value
 			end
 		end
 		return expense_value
	end

	def is_date_select(year = "Todos", month = "Todos", expense = nil)
		
		date_select = true
		
		if year != "Todos"
			if ( month_to_int(month) == expense.payment_date.month or
			 month == "Todos") and year.to_i == expense.payment_date.year 
				# date select is true
			else
				date_select = false
			end
		else
			# date_select true Will permit sum all expenses
		end

		if year == nil or month == nil
			date_select = true
		elsif year.empty? or month.empty?
			date_select = true
		end

		return date_select
	end

	def is_empty_filter(list_type_expenses)
		empty_filter = list_type_expenses.empty?
		if not empty_filter
			@expense_type_find = true
			# Find some expenes
		else
			@expense_type_find = false
			flash[:error] = "Não encontrol nenhuma despesa neste ano/mes:"
		end
		return empty_filter
	end

	def define_color(total_expense,list_type_expenses)	
		
		expense_per_cent = 0
		list_type_expenses.each do |expense|
			expense_per_cent = expense[:value]*100/total_expense
			expense_per_cent.to_i
			expense[:colorValue] = expense_per_cent

		end		
	end
end