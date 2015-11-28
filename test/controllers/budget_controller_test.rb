require 'test_helper'
require 'database_cleaner'

class BudgetControllerTest < ActionController::TestCase
  
  def setup
    FakeWeb.allow_net_connect = false

  

    SuperiorPublicAgency.create(id: 1,name: "valid SuperiorPublicAgency")

    PublicAgency.create(id: 1, views_amount: 0,name: "valid Agency",superior_public_agency_id: 1)
    PublicAgency.create(id: 2, views_amount: 0,name: "valid Agency 2",superior_public_agency_id: 1)

    Expense.create(document_number: "0000",payment_date: Date.new(2010,1,1),public_agency_id: 1,value: 500)
    Expense.create(document_number: "0001",payment_date: Date.new(2010,1,2),public_agency_id: 1,value: 500)
    Expense.create(document_number: "0002",payment_date: Date.new(2010,1,1),public_agency_id: 1,value: 1000)

    Expense.create(document_number: "0003",payment_date: Date.new(2015,1,1),public_agency_id: 2,value: 500)
    Expense.create(document_number: "0004",payment_date: Date.new(2015,2,1),public_agency_id: 2,value: 500)
    Expense.create(document_number: "0005",payment_date: Date.new(2015,3,1),public_agency_id: 2,value: 1000)
    
  end
  
  def teardown

    FakeWeb.allow_net_connect = true
    DatabaseCleaner.clean

  end

  test "Dont route to method show" do
    create_fake_budget_error
    assert_routing 'public_agency/2/budgets', controller: 'budget', action: 'show', id: '2'
    #get :show, id: 2
    assert_response :success
  end

  test "Route to method filter chart budget" do
    create_fake_budget
    assert_routing 'public_agency/2/filter', controller: 'budget', action: 'filter', id: '2'
    get :filter, id: 2
    assert_response :success  
    assert assigns(:list_budget_month)  
    assert assigns(:list_expense_month)
    assert assigns(:expense_find)
  end
  
  test "Should find something in interval" do
    create_fake_budget
    assert_routing 'public_agency/2/filter', controller: 'budget', action: 'filter', id: '2'
    get :filter, id: 2,year: 2015
    assert_response :success  
    assert assigns(:list_budget_month)  
    assert assigns(:list_expense_month)
    assert assigns(:expense_find)
  end

  test 'the subtract expense of expenses with budget' do
    create_fake_budget
    expense_controller = @controller.subtract_expenses_on_budget(2,2015)
    expected_array = [41500, 41000, 40000, 40000, 40000, 40000, 40000, 40000, 40000, 40000, 40000, 40000]
    assert_equal(expected_array, expense_controller )
  end

  test "Not find expenses in a interval" do

    date = Date.new(2015,1,8)
    expected_bool = false
    bool = @controller.is_date_in_interval("Fevereiro",2015,"Maio",2015, date)
    assert_equal(expected_bool,bool)

  end

  test "Should return a valid period" do
    data = Date.new(2015,06,01)
    boolean = @controller.is_date_in_interval("Janeiro",2015,"Dezembro",2015,data)
    expect_return = true
    assert_equal(expect_return,boolean) 
  end

  test "Should return an invalid period" do
    data = Date.new(2014,06,01)
    boolean = @controller.is_date_in_interval("Janeiro",2015,"Dezembro",2015,data)
    expect_return = false
    assert_equal(expect_return,boolean) 
  end

  test "List expense month is not empty" do

    list_expense_month = @controller.get_list_expenses_by_period(2, "Janeiro", 2015, "Dezembro", 2015)
    expense_find = @controller.get_list_expense_month(list_expense_month)
    expected_value = 1
    assert_equal(expense_find,expected_value)

  end
 
  test "Should return a not empty filter" do
    
    list_type_expenses = [1, 2, 3, 4, 5, 6]
    not_empty_list = @controller.is_empty_filter(list_type_expenses)
    assert_not (not_empty_list)
    
  end

  test "Should return a empty filter" do
    list_type_expenses = []
    empty_list = @controller.is_empty_filter(list_type_expenses)
    assert (empty_list)
  end

  test "Should return a equals hashs" do
    hash = {"01/2015"=>0, "02/2015"=>0, "03/2015"=>0, "04/2015"=>0, "05/2015"=>0, "06/2015"=>0, "07/2015"=>0, "08/2015"=>0, "09/2015"=>0, "10/2015"=>0, "11/2015"=>0, "12/2015"=>0}
    hash_return = @controller.initialize_hash(2015)
    assert_equal(hash_return, hash)
  end

  test "Should return diferents hashs" do
    hash = {"01/2015"=>12, "02/2015"=>19, "03/2015"=>1, "04/2015"=>9, "05/2015"=>15, "06/2015"=>89, "07/2015"=>0, "08/2015"=>78, "09/2015"=>100, "10/2015"=>5, "11/2015"=>60, "12/2015"=>0}
    hash_return = @controller.initialize_hash(2015)
    assert_not_equal(hash_return, hash)
  end


  test "Should return equals arrays" do
    hash = {2015=>{"01/2015"=>0, "02/2015"=>0, "03/2015"=>0, "04/2015"=>0, "05/2015"=>0, "06/2015"=>0, "07/2015"=>0, "08/2015"=>0, "09/2015"=>0, "10/2015"=>0, "11/2015"=>0, "12/2015"=>0}}
    array_expect = [["01/2015", 0], ["02/2015", 0], ["03/2015", 0], ["04/2015", 0], ["05/2015", 0], ["06/2015", 0], ["07/2015", 0], ["08/2015", 0], ["09/2015", 0], ["10/2015", 0], ["11/2015", 0], ["12/2015", 0]]
    array_return = @controller.transform_hash_to_array(hash)
    assert_equal(array_expect, array_return)
  end

  test "Should return diferents arrays" do
    hash = {2015=>{"01/2015"=>0, "02/2015"=>0, "03/2015"=>0, "04/2015"=>0, "05/2015"=>0, "06/2015"=>0, "07/2015"=>0, "08/2015"=>0, "09/2015"=>0, "10/2015"=>0, "11/2015"=>0, "12/2015"=>0}}
    array_expect = [[2015, ["01/2015", 0], ["02/2015", 0], ["03/2015", 0], ["04/2015", 0], ["05/2015", 0], ["06/2015", 0], ["07/2015", 0], ["08/2015", 0], ["09/2015", 0], ["10/2015", 0], ["11/2015", 0], ["12/2015", 0]]]
    array_return = @controller.transform_hash_to_array(hash)
    assert_not_equal(array_expect, array_return)
  end


  test "Should return a hash with expenses" do
    id_public_agency = 40
    public_agency_default = @controller.get_expenses_agency(id_public_agency)
    expense_value_init = {}
    assert_equal(expense_value_init,public_agency_default)
    
    id_public_agency = 1
    expected_data = {Date.new(2010,1,1)=>2000}
    public_agency = @controller.get_expenses_agency(id_public_agency)
    assert_equal(public_agency,expected_data)

    id_public_agency = 3
    public_agency_false = @controller.get_expenses_agency(id_public_agency)
    assert_equal(public_agency_false,{})        
  end

  test "Should return a ordenate array with expenses" do
    id_public_agency = 1
    data = @controller.get_list_expenses_by_period(id_public_agency)
    assert_not data.empty?

    expected_list = [["01/2010", 2000], ["02/2010", 0], ["03/2010", 0], ["04/2010", 0], ["05/2010", 0], ["06/2010", 0], ["07/2010", 0], ["08/2010", 0], ["09/2010", 0], ["10/2010", 0], ["11/2010", 0], ["12/2010", 0]]

    assert_equal(expected_list,data)
  end

  test "Should return a array with budget by month" do
    expenses = [["01/2015", 55], ["02/2015", 100], ["03/2015", 0], ["04/2015", 0], ["05/2015", 0], ["06/2015", 0], ["07/2015", 0], ["08/2015", 0], ["09/2015", 0], ["10/2015", 0], ["11/2015", 0], ["12/2015", 0]]
    budget = [{'year'=>2014, 'value'=>2055}]
    array_expect = [2000, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900]
    array_return = @controller.create_budget_array(expenses, budget, 2015)
    assert_equal(array_expect, array_return)
  end  

  def create_fake_budget
    url = 'http://aondebrasil.com:8890/sparql?default-graph-uri=&query='\
          'PREFIX%20rdf:%20%3Chttp://www.w3.org/1999/02/22-rdf-syntax-ns'\
          '%23%3E%20PREFIX%20loa:%20%3Chttp://vocab.e.gov.br/2013/09/loa'\
          '%23%3ESELECT%20?ano,%20(SUM(?valorProjetoLei)%20AS%20?somaProje'\
          'toLei)%20WHERE%20%7B?itemBlankNode%20loa:temExercicio%20?exercic'\
          'ioURI%20.%20?exercicioURI%20loa:identificador%202014%20'\
          '.%20?exercicioURI%20loa:identificador%20?ano%20.%20?itemBlankNod'\
          'e%20loa:temUnidadeOrcamentaria%20?uoURI%20.%20?uoURI%20loa:codig'\
          'o%20%222%22%20.%20?itemBlankNode%20loa:valorProjetoLei%20?va'\
          'lorProjetoLei%20.%20%7D&debug=on&timeout=&format=application%2Fs'\
          'parql-results%2Bjson&save=display&fname='
    url_all = 'http://aondebrasil.com:8890/sparql?default-graph-uri=&query=PREFIX'\
          '%20rdf:%20%3Chttp://www.w3.org/1999/02/22-rdf-syntax-ns%23%3E%20PR'\
          'EFIX%20loa:%20%3Chttp://vocab.e.gov.br/2013/09/loa%23%3ESELECT%20?'\
          'ano,%20(SUM(?valorProjetoLei)%20AS%20?somaProjetoLei)%20WHERE%20%7'\
          'B?itemBlankNode%20loa:temExercicio%20?exercicioURI%20.%20?exercici'\
          'oURI%20loa:identificador%20?ano%20.%20?itemBlankNode%20loa:temUnid'\
          'adeOrcamentaria%20?uoURI%20.%20?uoURI%20loa:codigo%20%222%22%2'\
          '0.%20?itemBlankNode%20loa:valorProjetoLei%20?valorProjetoLei%20.%2'\
          '0%7D&debug=on&timeout=&format=application%2Fsparql-results%2Bjson&'\
          'save=display&fname='
    content_body = '{"results":{"bindings":['\
          '{"ano": {"value": "2014"},"somaProjetoLei":{"value":"42000"}}]}}'
    FakeWeb.register_uri(:get, url, body: content_body)
    FakeWeb.register_uri(:get,url_all, body: content_body)
  end
  def create_fake_budget_error
    url_error = 'http://aondebrasil.com:8890/sparql?default-graph-uri=&query=PREFIX'\
          '%20rdf:%20%3Chttp://www.w3.org/1999/02/22-rdf-syntax-ns%23%3E%20PR'\
          'EFIX%20loa:%20%3Chttp://vocab.e.gov.br/2013/09/loa%23%3ESELECT%20?'\
          'ano,%20(SUM(?valorProjetoLei)%20AS%20?somaProjetoLei)%20WHERE%20%7'\
          'B?itemBlankNode%20loa:temExercicio%20?exercicioURI%20.%20?exercici'\
          'oURI%20loa:identificador%20?ano%20.%20?itemBlankNode%20loa:temUnid'\
          'adeOrcamentaria%20?uoURI%20.%20?uoURI%20loa:codigo%20%222%22%2'\
          '0.%20?itemBlankNode%20loa:valorProjetoLei%20?valorProjetoLei%20.%2'\
          '0%7D&debug=on&timeout=&format=application%2Fsparql-results%2Bjson&'\
          'save=display&fname='
    FakeWeb.register_uri(:get, url_error,body: "{'results: {}'}")
  end

end