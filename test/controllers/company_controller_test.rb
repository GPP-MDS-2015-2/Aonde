require 'test_helper'

class CompanyControllerTest < ActionController::TestCase
#=begin
  test 'Route to method show and the result of the request' do
    generate_public_agency
    assert_routing 'public_agency/1/company', controller: 'company', action: 'show', id: '1'
    get :show, id: 1
    assert_response :success
    assert assigns :array_company_expense
  end

  test 'should return a ordered hash' do
    hash = { 'key1' => 12, 'key2' => 8, 'key3' => 10 }
    hash = @controller.sort_by_expense(hash)
    ordered_hash = { 'key2' => 8, 'key3' => 10, 'key1' => 12 }.to_a
    assert_equal(hash, ordered_hash)
  end

  test 'should validate an array of companies' do
    company1 = Company.new(id: 1000, name: 'company 1')
    company2 = Company.new(id: 1001, name: 'company 2')

    company_multiples = [company1, company2]

    expense = Expense.new(value: 100, payment_date: Date.new, document_number: '0000')
    hash_companies_multiple = {}
    @controller.test_add_expense(company_multiples, expense, hash_companies_multiple)
    assert hash_companies_multiple.empty?

    company_empty = []
    hash_companies_empty = {}
    @controller.test_add_expense(company_empty, expense, hash_companies_empty)
    assert hash_companies_empty.empty?

    company_single = [company1]
    hash_companies_valid = {}
    @controller.test_add_expense(company_single, expense, hash_companies_valid)
    assert_not hash_companies_valid.empty?
  end

  test 'should find a company' do
    expenses = generate_expense
    expense = @controller.find_company(expenses)
    expense_expected = [['CIA', 6], ['Comercial', 15]]
    assert_equal(expense, expense_expected)

    a = []
    expense_empty = @controller.find_company(a)
    assert expense_empty.empty?
  end

  test 'should return a array with key company name and value expense value' do
    company_expenses = { 'company1' => 1, 'company2' => 2, 'company3' => 3 }
    company_empty = {}
    company = generate_companies

    expense = Expense.create(id: 2, value: 5)

    company_expected = { 'company1' => 6, 'company2' => 2, 'company3' => 3 }
    @controller.testing_companies(company, expense, company_expenses)
    assert_equal(company_expenses, company_expected)

    company_expected2 = { 'company1' => 5 }
    @controller.testing_companies(company, expense, company_empty)
    assert_equal(company_empty, company_expected2)
  end

  test 'should return an array with a few nodes' do
    hash = [{ 'nome1' => 1 }, { 'nome2' => 2 }, { 'nome3' => 3 },
            { 'nome4' => 4 }, { 'nome5' => 5 }, { 'nome6' => 6 },
            { 'nome7' => 7 }, { 'nome8' => 8 }, { 'nome9' => 9 },
            { 'nome10' => 10 }, { 'nome11' => 11 }, { 'nome12' => 12 },
            { 'nome13' => 13 }, { 'nome14' => 14 }, { 'nome15' => 15 },
            { 'nome16' => 16 }, { 'nome17' => 17 }, { 'nome18' => 18 }
           ]
    few_hash = [{ 'nome18' => 18 }, { 'nome17' => 17 }, { 'nome16' => 16 },
                { 'nome15' => 15 }, { 'nome14' => 14 }, { 'nome13' => 13 },
                { 'nome12' => 12 }, { 'nome11' => 11 }, { 'nome10' => 10 },
                { 'nome9' => 9 }, { 'nome8' => 8 }, { 'nome7' => 7 },
                { 'nome6' => 6 }, { 'nome5' => 5 }, { 'nome4' => 4 }]
    test_hash = @controller.get_15_first_nodes(hash)

    assert_equal(few_hash, test_hash)
  end

  test 'should return an array with 8 nodes but ordered by value' do
    hash = [{ 'nome1' => 1 }, { 'nome2' => 2 }, { 'nome3' => 3 },
            { 'nome4' => 4 }, { 'nome5' => 5 }, { 'nome6' => 6 },
            { 'nome7' => 7 }, { 'nome8' => 8 }]
    few_hash = [{ 'nome8' => 8 }, { 'nome7' => 7 }, { 'nome6' => 6 },
                { 'nome5' => 5 }, { 'nome4' => 4 }, { 'nome3' => 3 },
                { 'nome2' => 2 }, { 'nome1' => 1 }]
    test_hash = @controller.get_15_first_nodes(hash)

    assert_equal(few_hash, test_hash)
  end

  test 'should return a node' do
    node = [
      { 'data' => { 'id' => 'empresa' }, 'position' => { 'x' => 0, 'y' => 400 } },
      { 'data' => { 'id' => 'Órgãos Públicos' } }, { 'data' => { 'id' => 'qtde Contratações' } }
    ]

    node_test = @controller.generate_company_node('empresa')

    assert_equal(node, node_test)
  end

  test 'should return a especific expense' do
    public_agency = PublicAgency.new(id: 1)
    expense = Expense.where(public_agency_id: public_agency.id).count

    test_expense = @controller.find_hiring_count(public_agency)

    assert_equal(expense, test_expense)
  end

  test 'should return a public_agency node' do
    few_hash = { 'nome2' => 2, 'nome3' => 3, 'nome1' => 1,
                 'nome4' => 4, 'nome5' => 5, 'nome11' => 11,
                 'nome7' => 7, 'nome8' => 8, 'nome15' => 15,
                 'nome10' => 10, 'nome6' => 6, 'nom12' => 12,
                 'nome13' => 13, 'nome14' => 14, 'nome9' => 9
               }

    company_node = [
      { 'data' => { 'id' => 'empresa' }, 'position' =>
      { 'x' => 0, 'y' => 400 } },
      { 'data' => { 'id' => 'Órgãos Públicos' } },
      { 'data' => { 'id' => 'qtde Contratações' } }
    ]

    node = generate_generic_node('empresa', few_hash, company_node)
    test_node = @controller.generate_public_agency_node('empresa', few_hash, company_node)

    assert_equal(node, test_node)
  end
#=end
  test 'should return a number' do
    hash = { 'nome2' => 2, 'nome2' => 2, 'nome1' => 1,
                 'nome4' => 4, 'nome5' => 5, 'nome11' => 11,
                 'nome7' => 7, 'nome2' => 2, 'nome15' => 15,
                 'nome10' => 10, 'nome6' => 6, 'nom12' => 12,
                 'nome13' => 13, 'nome14' => 14, 'nome9' => 9
            }
    correct_hash = hash.sort_by { |name, expense| expense }
    public_agency = PublicAgency.new(name: "name1", id: 1)

    controller_hash = @controller.verify_insert(hash, public_agency)

    puts "\n\n\n 1: #{controller_hash} \n\n\n"
    puts "\n\n\n 2: #{correct_hash} \n\n\n"

    assert_equal(controller_hash, correct_hash)
  end

  def generate_public_agency
    SuperiorPublicAgency.create(id: 1, name: 'valid SuperiorPublicAgency')
    PublicAgency.create(id: 1, views_amount: 0, name: 'valid Agency', superior_public_agency_id: 1)
  end

  def generate_companies
    companies = []
    nome_company = %w(company1 company2 company3)

    i = 0
    3.times do
      created_company = Company.create(name: nome_company[i])
      companies[i] = created_company
      i += 1
    end
    companies
  end

  def generate_expense
    nome_company = %w(CIA Comercial)
    array = []

    i = 1
    2.times do
      date = Date.new(2015, i, i)
      company = Company.create(name: nome_company[i - 1])
      2.times do
        expenses = Expense.create(document_number: i, payment_date: date, value: i + 5, company_id: company.id)
        array[i - 1] = expenses
        i += 1
      end
      i -= 1
    end

    array
  end

  # Need reafctor
  def generate_generic_node(company_name, hash, company_node)
    count = 1
    array_general = []
    edges = []
    hash.each do |name, number|
      name = name.to_s
      hash_public_agency = { 'data' => { 'id' => name,
                                         'parent' => 'Órgãos Públicos' },
                             'position' => { 'x' => 400, 'y' => count * 50 } },
                           hash_hiring = { 'data' => { 'id' => number,
                                                       'parent' => 'qtde Contratações' },
                                           'position' => { 'x' => 700, 'y' => count * 50 } }

      company_node << hash_public_agency
      company_node << hash_hiring

      count += 1

      hash_edge_to_company = { 'data' => { 'source' => name,
                                           'target' => company_name } }
      hash_edge_to_public_agency = { 'data' => { 'source' => number,
                                                 'target' => name } }

      edges << hash_edge_to_company
      edges << hash_edge_to_public_agency
    end
    array_general << company_node

    array_general << edges
    # puts "\n\n\n #{array_general} \n\n\n"
  end
end
