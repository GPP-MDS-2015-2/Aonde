class CompanyController < ApplicationController

	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])	
		@expenses = Expense.all			
	end

	def find_expenses
		find_public_agency
		expenses_public_agency = Expense.where(public_agency_id: @public_agency.id)
		@a = find_company(expenses_public_agency)
		@a.to_json
	end

	def find_company(expenses_public_agency)

		#company = []
		companies = []

		expenses_public_agency.each do |expense|

			company = Company.where(id: expense.company_id)
			companies << [company.name,company.id]

		end
		return companies
	end

	def show
		find_expenses
	end


end