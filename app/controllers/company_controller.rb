class CompanyController < ApplicationController

	def show
		find_public_agency
		expenses_public_agency = Expense.where(public_agency_id: @public_agency.id)
		@a = find_company(expenses_public_agency)
		@a.to_json
	end

	def find_public_agency
		@public_agency = PublicAgency.find(params[:id])	
	end

	def find_company(expenses_public_agency)

		companies_expense = {}

		expenses_public_agency.each do |expense|

			company = Company.where(id: expense.company_id)
			test_add_expense(company,expense,companies_expense)

		end
	
		return sort_by_expense(companies_expense)

	end

	#assert that company array is not empty
	def test_add_expense(company,expense,companies_expense)
		if not company.empty? and company.length == 1
			testing_companies(company,expense,companies_expense)
		else
			#do nothing
		end
	end

	def testing_companies(company,expense,companies_expense)
					
			company = company[0]
			if not companies_expense [company.name]
	      		companies_expense [company.name] = expense.value
	    	else
	    		companies_expense[company.name] += expense.value
	    	end

	end

	def sort_by_expense(companies_expense)
		companies_expense.sort_by{ |name, expense| expense}
	end

end