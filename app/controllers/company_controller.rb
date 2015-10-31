class CompanyController < ApplicationController
  def show
    find_public_agency
    expenses_public_agency = Expense.where(public_agency_id: @public_agency.id)
    @array_company_expense = find_company(expenses_public_agency)
    @array_company_expense.to_json
  end

  def find_public_agency
    @public_agency = PublicAgency.find(params[:id])
    @superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)
  end

  def find_company(expenses_public_agency)
    companies_expense = {}

    expenses_public_agency.each do |expense|
      company = Company.where(id: expense.company_id)
      test_add_expense(company, expense, companies_expense)
    end

    return sort_by_expense(companies_expense)
  end

  # assert that company array is not empty
  def test_add_expense(company, expense, companies_expense)
    if !company.empty? && company.length == 1
      testing_companies(company, expense, companies_expense)
    end
  end

  def testing_companies(company, expense, companies_expense)
    company = company[0]
    if !companies_expense [company.name]
      companies_expense [company.name] = expense.value
    else
      companies_expense[company.name] += expense.value
     end
  end

  def sort_by_expense(companies_expense)
    companies_expense.sort_by { |_name, expense| expense }
  end

######################################### View hiring incidence ######################


  def index
    # 		expenses = Expense.where(company_id: params[:id])
    # 		@array_programs_public_agencies = find_programs_and_public_agencies(expenses)=end
  end

  def find_public_agencies(expenses)
    company_hiring_incidence  = {}
    expenses.each do |expense|
      public_agency = PublicAgency.find(expenses.public_agency_id)     
      verify_insert(company_hiring_incidence,public_agency,counting)
    end
  end

  def find_hiring_count(public_agency)
    
    counting = Expense.where(public_agency_id: public_agency.id).count

  end

  def verify_insert(company_hiring_incidence,public_agency,counting)

    if ! company_hiring_incidence[public_agency.name]
      counting = find_hiring_count(public_agency)
      company_hiring_incidence [public_agency.name] = counting
    end

  end

end
