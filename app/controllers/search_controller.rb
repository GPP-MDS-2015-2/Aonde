class SearchController < ApplicationController
	
	def index 
		search = params[:search]
		@entity = params[:entity]
		@msg_error = 1
		if search.length < 4
			flash[:error] = "A Pesquisa não pode ter menos que 4 caracteres"
			@msg_error = 0
			@results = []
		else
			@public_agencies = PublicAgency.where("name LIKE ?", "%#{search}%")
			@total_expense_agency = {}
			@public_agencies.each do |agency|
				@total_expense_agency[agency.id] = expenses_public_agency(agency.id)
			end
			@programs = Program.where("name LIKE ?", "%#{search}%")
			@total_expense_program = {}
			@programs.each do |program|
				@total_expense_program[program.id] = expenses_program(program.id)
			end
			@companies = Company.where("name LIKE ?", "%#{search}%")
			@total_expense_company = {}
			@companies.each do |company|
				@total_expense_company[company.id] = expenses_company(company.id)
			end
			@results = [1]
		end
	end

	def expenses_public_agency(id_pub_agency)
	  	total_expense = Expense.where(public_agency_id: id_pub_agency).sum(:value)
	  	return total_expense
	end

	def expenses_program(id_program)
	  	total_expense = Expense.where(program_id: id_program).sum(:value)
	  	return total_expense
	end

	def expenses_company(id_company)
	  	total_expense = Expense.where(company_id: id_company).sum(:value)
	  	return total_expense
	end

end