# company_controller.rb
# Process the expenses of companies to create chart related to a public agency
# or a graph with all public agencies make hires
class CompanyController < ApplicationController
  def show
    find_agencies(params[:id])
    array_company_expense = find_company_and_expenses_array
 
    respond_to do |format|
      format.json { render json: array_company_expense}
    end

  end

  def find_company_and_expenses_array

    Expense.joins(:company)
    .where(public_agency_id: @public_agency.id).select(:name)
    .order('sum_value DESC').group(:name).sum(:value).to_a  

  end

  ######################################### View hiring incidence ######################

  def find
    expenses = Expense.where(company_id: params[:id])
    company_hiring_incidence = find_public_agencies(expenses)
    # company_hiring_incidence = get_15_first_nodes(company_hiring_incidence)
    company_name = Company.find(params[:id]).name
    data_company = generate_company_node(company_name)
    array = generate_public_agency_node(company_name, company_hiring_incidence,
                                        data_company)
    @correct_datas = array.to_json
  end

  def get_15_first_nodes(company_hiring_incidence)
    final_array = []
    length = company_hiring_incidence.length

    if length < 15

      length.times do
        final_array.push(company_hiring_incidence[length - 1])
        length -= 1
      end

    else

      15.times do
        final_array.push(company_hiring_incidence[length - 1])
        length -= 1
      end

  end

    final_array
  end

  def find_public_agencies(expenses)
    company_hiring_incidence = {}
    expenses.each do |expense|
      unless expense.public_agency_id.nil?
        public_agency = PublicAgency.find(expense.public_agency_id)
        verify_insert(company_hiring_incidence, public_agency)
      end
    end
    company_hiring_incidence.sort_by { |_name, expense| expense }
  end

  def find_hiring_count(public_agency)
    counting = Expense.where(public_agency_id: public_agency.id).count
  end

  def verify_insert(company_hiring_incidence, public_agency)
    unless company_hiring_incidence[public_agency.name]
      counting = find_hiring_count(public_agency)
      company_hiring_incidence[public_agency.name] = counting
    end
  end

  def generate_company_node(company_name)
    data_company = [
      { 'data' => { 'id' => company_name }, 'position' => { 'x' => 0,
                                                            'y' => 400 } },
      { 'data' => { 'id' => 'Órgãos Públicos' } },
      { 'data' => { 'id' => 'qtde Contratações' } }
    ]
  end

  def generate_public_agency_node(company_name, company_hiring_incidence,
    data_company)
    count = 1
    array_general = []
    edges = []
    company_hiring_incidence.each do |public_agency_name, hiring|
      public_agency_name = public_agency_name.to_s
      hash_public_agency = { 'data' => { 'id' => public_agency_name,
                                         'parent' => 'Órgãos Públicos' },
                             'position' => { 'x' => 400, 'y' => count * 50 } }
      hash_hiring = { 'data' => { 'id' => hiring, 'parent' => 'qtde Contrataç'\
        'ões' }, 'position' => { 'x' => 700, 'y' => count * 50 } }

      data_company << hash_public_agency
      data_company << hash_hiring
      count += 1

      hash_edge_to_company = { 'data' => { 'source' => public_agency_name,
                                           'target' => company_name } }
      hash_edge_to_public_agency = { 'data' => {
        'source' => hiring, 'target' => public_agency_name } }

      edges << hash_edge_to_company
      edges << hash_edge_to_public_agency
    end

    array_general << data_company
    array_general << edges
  end
end
