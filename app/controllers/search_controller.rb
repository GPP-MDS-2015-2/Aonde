class SearchController < ApplicationController
	
	def index 
		search = params[:search]
		@entity = params[:entity]
		@msg_error = 1
		if search.length >= 4
			search_entities
			@results = [1]			
		else
			flash[:error] = "A Pesquisa não pode ter menos que 4 caracteres"
			@msg_error = 0
			@results = []	
		end
	end

	def search_entities
	 	name_field = params[:search]
	 	@public_agencies = PublicAgency.where("name LIKE ?", "%#{name_field}%")
		@total_expense_agency = {}
		@public_agencies.each do |agency|
			@total_expense_agency[agency.id] = expense_entities(:public_agency_id,agency.id)
		end
		@programs = Program.where("name LIKE ?", "%#{name_field}%")
		@total_expense_program = {}
		@programs.each do |program|
			@total_expense_program[program.id] = expense_entities(:program_id,program.id)
		end
		@companies = Company.where("name LIKE ?", "%#{name_field}%")
		@total_expense_company = {}
		@companies.each do |company|
			@total_expense_company[company.id] = expense_entities(:company_id,company.id)
		end
	end 

	def expense_entities(name_field,entity_id)
		total_expense = Expense.where(name_field=> entity_id).sum(:value)
	  	return total_expense
	end

end