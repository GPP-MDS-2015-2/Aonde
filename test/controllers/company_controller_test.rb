require 'test_helper'
require 'database_cleaner'

class CompanyControllerTest < ActionController::TestCase
  def setup
    SuperiorPublicAgency.create(id: 1, name: 'valid SuperiorPublicAgency')
    PublicAgency.create(id: 1, views_amount: 0, name: 'orgao3', superior_public_agency_id: 1)
    PublicAgency.create(id: 2, views_amount: 0, name: 'orgao2', superior_public_agency_id: 1)
    date = Date.new(2015, 1, 2)
    public_agency_first = PublicAgency.first
    public_agency_second = PublicAgency.second
    Expense.create(document_number: 1, payment_date: date, value: 5, public_agency_id: 1)
    Expense.create(document_number: 2, payment_date: date, value: 9, public_agency_id: 1)
    Expense.create(document_number: 3, payment_date: date, value: 13, public_agency_id: 2)

    nome_company = %w(CIA Comercial)
    array = []
    i = 1
    2.times do
      date = Date.new(2015, i, i)
      company = Company.create(id: i, name: nome_company[i - 1])
      2.times do
        Expense.create(document_number: i, payment_date: date, value: i + 5, company_id: company.id)
        i += 1
      end
      i -= 1
    end
  end

  def teardown
    DatabaseCleaner.clean
  end

  #   test 'Route to method show and the result of the request' do
  #
  #     get :show, id: 1
  #     assert_response :success
  #
  #   end

  test 'Route to method find and the result of the request' do
    assert_routing '/company/1', controller: 'company', action: 'find', id: '1'
    get :find, id: 1
    assert_response :success
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
    few_hash = { 'nome2' => 2, 'nome3' => 3, 'nome1' => 1
               }

    company_node = [
      { 'data' => { 'id' => 'empresa' }, 'position' =>
      { 'x' => 0, 'y' => 400 } },
      { 'data' => { 'id' => 'Órgãos Públicos' } },
      { 'data' => { 'id' => 'qtde Contratações' } }
    ]

    node = [[{ 'data' => { 'id' => 'empresa' }, 'position' => { 'x' => 0, 'y' => 400 }
    }, { 'data' => { 'id' => 'Órgãos Públicos' } }, { 'data' =>     { 'id' => 'qtde Contratações' } }, { 'data' =>     { 'id' => 'nome2', 'parent' => 'Órgãos Públicos' }, 'position' =>     { 'x' => 400, 'y' => 50 } }, { 'data' => { 'id' => 2, 'parent' => 'qtde Contratações'
    }, 'position' => { 'x' => 700, 'y' => 50 } }, { 'data' =>     { 'id' => 'nome3', 'parent' => 'Órgãos Públicos' }, 'position' =>     { 'x' => 400, 'y' => 100 } }, { 'data' => { 'id' => 3, 'parent' => 'qtde Contratações'
    }, 'position' => { 'x' => 700, 'y' => 100 } }, { 'data' =>     { 'id' => 'nome1', 'parent' => 'Órgãos Públicos' }, 'position' =>     { 'x' => 400, 'y' => 150 } }, { 'data' => { 'id' => 1, 'parent' => 'qtde Contratações'
    }, 'position' => { 'x' => 700, 'y' => 150 } }], [{ 'data' =>     { 'source' => 'nome2', 'target' => 'empresa' } }, { 'data' =>     { 'source' => 2, 'target' => 'nome2' } }, { 'data' =>     { 'source' => 'nome3', 'target' => 'empresa' } }, { 'data' =>     { 'source' => 3, 'target' => 'nome3' } }, { 'data' =>     { 'source' => 'nome1', 'target' => 'empresa' } }, { 'data' =>     { 'source' => 1, 'target' => 'nome1' } }]]

    test_node = @controller.generate_public_agency_node('empresa', few_hash, company_node)

    assert_equal(node, test_node)
  end

  test 'should find public agencies' do
    expenses = Expense.all
    expected_hash = [['orgao2', 1], ['orgao3', 2]]
    hash_returned = @controller.find_public_agencies(expenses)

    assert_equal(expected_hash, hash_returned)
  end

  test 'should find hiring count' do
    public_agency = PublicAgency.first
    counting = @controller.find_hiring_count(public_agency)
    expected_counting = 2

    assert_equal(counting, expected_counting)
  end
end
