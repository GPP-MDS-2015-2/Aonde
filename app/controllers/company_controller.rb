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
    expenses = Expense.where(company_id: params[:id])
    company_hiring_incidence = find_public_agencies(expenses)
    company_name = get_name_company
    get_name_hash(company_name, company_hiring_incidence)
  end

  def find_public_agencies(expenses)
    company_hiring_incidence  = {}
    expenses.each do |expense|
      public_agency = PublicAgency.find(expenses.public_agency_id)
      verify_insert(company_hiring_incidence,public_agency,counting)
    end
    return company_hiring_incidence
  end

  def find_hiring_count(public_agency)
    counting = Expense.where(public_agency_id: public_agency.id).count
  end

  def verify_insert(company_hiring_incidence,public_agency,counting)
    if ! company_hiring_incidence[public_agency.name]
      counting = find_hiring_count(public_agency)
      company_hiring_incidence[public_agency.name] = counting
    end
  end

  def get_name_company
    company_name = Company.find(params[:id]).name
    return company_name
  end

  def generate_position_x(node)
    i = 100
  end

  def generate_position_y(node)
    i = 80
  end

  def generate_company_node(company_name)
    data_company = [
      { "data" => { id => company_name }, position => { x => 100, y => 80 } },
      { "data" => { id => 'Órgãos Públicos' } },{ "data" => { id => 'qtde Contratações' } },
    ]
  end

  def generate_public_agency_node(company_hiring_incidence, node, data_company)
    node = 1
    company_hiring_incidence.each do |public_agency_name, hiring|
      public_agency_name = public_agency_name.to_s
      { "data" => { id => public_agency_name, parent => 'Órgãos Públicos' }, position => { x => generate_position_x(node), y => generate_position_y(node) } },
    end

    return node.push(hash)

  end

end


=begin
elements: {
    nodes: [
      { "data": { id: 'Empresas' }, position: { x: 100, y: 80 } },
      { "data": { id: 'Ministério2', parent: 'Órgãos Públicos' }, position: { x: 200, y: 80 } },
      { "data": { id: 'qtde Contratações' } },
      { "data": { id: '37', parent: 'qtde Contratações' }, position: { x: 350, y: 30 } },
      { "data": { id: 'Órgãos Públicos' } },
      { "data": { id: 'Ministério1', parent: 'Órgãos Públicos' }, position: { x: 200, y: 30 } },
    ],
    edges: [
      { data: { id: 'Ministério2Empresas', source: 'Ministério2', target: 'Empresas' } },
      { data: { id: '37Ministério1', source: '37', target: 'Ministério1' } },
      { data: { id: 'Ministério1Empresas', source: 'Ministério1', target: 'Empresas' } }
      
    ]
  }
=end
