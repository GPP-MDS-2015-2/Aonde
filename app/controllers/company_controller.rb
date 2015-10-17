class CompanyController < ApplicationController

	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])	
	end

	def find_expenses
		find_public_agency
		expenses_public_agency = Expense.where(public_agency_id: @public_agency.id)
		@a = find_company(expenses_public_agency).to_a
		@a.to_json
	end

	def find_company(expenses_public_agency)

		#company = []
		companies_expense = {}

		expenses_public_agency.each do |expense|

			company = Company.where(id: expense.company_id)
			#
			if not company.empty? and company.length == 1
				
				company = company[0]
				if not companies_expense [company.name]
	          		companies_expense [company.name] = expense.value
	        	else
	        		companies_expense[company.name] += expense.value
	        	end

	        end
		end
		return companies_expense.sort_by{ |date, expense| expense}
	end

	def show
		find_expenses
	end


end