require 'test_helper'

class CompanyControllerTest < ActionController::TestCase
	
  test 'Route to method show and the result of the request' do
    generate_public_agency
    assert_routing 'public_agency/1/companies', controller: 'company', action: 'show', id: '1'
    
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
               }

    company_node = [
      { 'data' => { 'id' => 'empresa' }, 'position' =>
      { 'x' => 0, 'y' => 400 } },
      { 'data' => { 'id' => 'Órgãos Públicos' } },
      { 'data' => { 'id' => 'qtde Contratações' } }
    ]

    node = [[{"data"=>{"id"=>"empresa"}, "position"=>{"x"=>0, "y"=>400}
    }, {"data"=>{"id"=>"Órgãos Públicos"}}, {"data"=>
    {"id"=>"qtde Contratações"}}, {"data"=>
    {"id"=>"nome2", "parent"=>"Órgãos Públicos"}, "position"=>
    {"x"=>400, "y"=>50}}, {"data"=>{"id"=>2, "parent"=>"qtde Contratações"
    }, "position"=>{"x"=>700, "y"=>50}}, {"data"=>
    {"id"=>"nome3", "parent"=>"Órgãos Públicos"}, "position"=>
    {"x"=>400, "y"=>100}}, {"data"=>{"id"=>3, "parent"=>"qtde Contratações"
    }, "position"=>{"x"=>700, "y"=>100}}, {"data"=>
    {"id"=>"nome1", "parent"=>"Órgãos Públicos"}, "position"=>
    {"x"=>400, "y"=>150}}, {"data"=>{"id"=>1, "parent"=>"qtde Contratações"
    }, "position"=>{"x"=>700, "y"=>150}}], [{"data"=>
    {"source"=>"nome2", "target"=>"empresa"}}, {"data"=>
    {"source"=>2, "target"=>"nome2"}}, {"data"=>
    {"source"=>"nome3", "target"=>"empresa"}}, {"data"=>
    {"source"=>3, "target"=>"nome3"}}, {"data"=>
    {"source"=>"nome1", "target"=>"empresa"}}, {"data"=>
    {"source"=>1, "target"=>"nome1"}}]]

    test_node = @controller.generate_public_agency_node('empresa', few_hash, company_node)

    assert_equal(node, test_node)
  end

  test 'should find public agencies' do
    generate_public_agency
    expenses = Expense.all
    expected_hash = [["orgao2",1],["orgao3",2]]
    hash_returned = @controller.find_public_agencies(expenses)

    assert_equal(expected_hash,hash_returned)
  end

  test 'should find hiring count' do
    generate_public_agency
    public_agency = PublicAgency.first
    counting = @controller.find_hiring_count(public_agency)
    expected_counting = 2
    
    assert_equal(counting,expected_counting)
  end

  def generate_public_agency
    SuperiorPublicAgency.create(id: 1, name: 'valid SuperiorPublicAgency')
    PublicAgency.create(id: 1, views_amount: 0, name: 'orgao3', superior_public_agency_id: 1)
    PublicAgency.create(id: 2, views_amount: 0, name: 'orgao2', superior_public_agency_id: 1)
    date = Date.new(2015, 1, 2)
    public_agency_first = PublicAgency.first
    public_agency_second = PublicAgency.second
    Expense.create(document_number: 1, payment_date: date, value: 5, public_agency_id: 1)
    Expense.create(document_number: 2, payment_date: date, value: 9, public_agency_id: 1)        
    Expense.create(document_number: 3, payment_date: date, value: 13, public_agency_id: 2)           
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
end
