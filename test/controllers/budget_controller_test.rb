require 'test_helper'

class BudgetControllerTest < ActionController::TestCase
=begin
  FIx that tests
  test "Routes to method filter_chart_budget" do
    create_public_agency
    get :filter_chart_budget, id: 2, year: "2015"
    assert_response :success
    assert assigns(:list_expense_month)
    assert assigns(:expense_find)
    assert assigns(:list_budget_month)
  end
  test "Test of method subtract_expenses_on_budget" do
    create_public_agency
    id_public_agency = 2
    array_expect = [5252423, 5251923, 5250923, 5250923, 5250923, 5250923, 5250923, 5250923, 5250923, 5250923, 5250923, 5250923]
    array_return = @controller.subtract_expenses_on_budget(id_public_agency, 2015)
    assert_equal(array_expect, array_return)
  end
  test "Route to method show and the result of the request" do
    create_public_agency        
      assert_routing '/public_agency/1/budgets', { :controller => "budget", :action => "show", :id => "1" } 
    get :show, id: 2

    assert_response :success

    assert assigns(:list_expense_month)
    assert assigns(:expense_find)
    assert assigns(:list_budget_month)
  end
=end
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
    id_public_agency = 1
    public_agency_default = @controller.get_expenses_agency(id_public_agency)
    expense_value_init = {}
    assert_equal(expense_value_init,public_agency_default)
    
    create_public_agency
    
    id_public_agency = 1
    expected_data = {Date.new(2010,1,1)=>2000}
    public_agency = @controller.get_expenses_agency(id_public_agency)
    assert_equal(public_agency,expected_data)


    id_public_agency = 3
    public_agency_false = @controller.get_expenses_agency(id_public_agency)
    assert_equal(public_agency_false,{})        

  end

  test "Should return a ordenate array with expenses" do
    create_public_agency
    id_public_agency = 1
    data = @controller.get_list_expenses_by_period(id_public_agency)
    assert_not data.empty?

    expected_list = [["01/2010", 2000], ["02/2010", 0], ["03/2010", 0], ["04/2010", 0], ["05/2010", 0], ["06/2010", 0], ["07/2010", 0], ["08/2010", 0], ["09/2010", 0], ["10/2010", 0], ["11/2010", 0], ["12/2010", 0]]

    assert_equal(expected_list,data)
  end

  test "Should return a array with budget by month" do
    expenses = [["01/2015", 55], ["02/2015", 100], ["03/2015", 0], ["04/2015", 0], ["05/2015", 0], ["06/2015", 0], ["07/2015", 0], ["08/2015", 0], ["09/2015", 0], ["10/2015", 0], ["11/2015", 0], ["12/2015", 0]]
    budget = [{'year'=>2015, 'value'=>2055}]
    array_expect = [2000, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900, 1900]
    array_return = @controller.create_budget_array(expenses, budget, 2015)
    assert_equal(array_expect, array_return)
  end


	def create_public_agency
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
	
  test 'the budgets not null' do
    create_fake_web
    FakeWeb.allow_net_connect = false
    budgets_not_nil = @controller.get_budget(20000)
    assert_not_nil(budgets_not_nil)
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end
  
  test 'the empty return result of budgets' do
    create_fake_web
    FakeWeb.allow_net_connect = false
    not_exist_id = -1
    assert_raises(Exception) do
      budget_epmty = @controller.get_budget(not_exist_id)
    end
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end

  test 'create the query of an year' do
    correct_query = '?exercicioURI loa:identificador 2013 . '
    query = @controller.query_for_year('2013')
    assert_equal(correct_query, query)
  end

  test 'the result empty of a year' do
    query_empty = @controller.query_for_year('Todos')
    assert_empty(query_empty)
  end

  test 'the valid hash with budget' do
    budgets_data = {'results' => {'bindings' => [0]}}
    assert(@controller.valid_data?(budgets_data))
  end

  test 'the empty bindings' do
    budgets_data = {'results' => {'bindings' => []}}
    assert_not(@controller.valid_data?(budgets_data))
  end

  test 'the empty results' do
    budgets_data = {'results' => {}}
    assert_not(@controller.valid_data?(budgets_data))
  end

  test 'the null results' do
    budgets_data = {'results' => nil}
    assert_not(@controller.valid_data?(budgets_data))
  end

  test 'the null bindings' do
    budgets_data = {'results' => {'bindings' => nil}}
    assert_not(@controller.valid_data?(budgets_data))
  end


  test 'the size grow of budget by year' do
    budget_hash = { 'results' => { 'bindings' =>[create_budget,create_budget]}}
    budget_years = []
    @controller.add_budget_array(budget_years,budget_hash)
    expected_size = 2
    assert_equal(expected_size,budget_years.size)
  end
  test 'not grow size of array budget by year' do
    whithout_budget_hash = {'results'=>{'bindings'=>[]}}
    budget_empty = []
    @controller.add_budget_array(budget_empty,whithout_budget_hash)
    assert_empty(budget_empty)
  end
  test 'insertion of one budget in the array' do
    one_budget_hash = {'results'=>{'bindings'=>[create_budget]}}
    budget_years = []
    @controller.add_budget_array(budget_years,one_budget_hash)
    expected_array = [{'year'=>2011,'value'=>123456}]
    assert_equal(expected_array,budget_years)
  end

  test 'the create of hash with budget' do
    budget_hash=create_budget
    budget_correct = @controller.create_budget_year(budget_hash)
    expected_budget = {"year"=>2011,"value" => 123456 }
    assert_equal(expected_budget,budget_correct)
  end
  test 'not null budget return' do
    budget_hash=create_budget
    budget_correct = @controller.create_budget_year(budget_hash)
    assert_not_nil(budget_correct)
  end
  test 'empty budget return' do
    budget_hash= {"ano" => {"value" => nil},"somaProjetoLei" => {"value"=> "123456"}}
    budget_epmty = @controller.create_budget_year(budget_hash)
    assert_empty(budget_epmty)
  end


  test 'the budget query encode' do
    year = '2015'
    public_agency_id = '1'

    query_encode_expected = URI.encode(create_query(public_agency_id, year))
    query_encode = @controller.generate_query(public_agency_id, year)

    assert_equal(query_encode_expected, query_encode)
  end

  test 'the budget query not encode' do
    year = '2012'
    public_agency_id = '2'
    query_not_encode = create_query(public_agency_id, year)
    query_encode = @controller.generate_query(public_agency_id, year)

    assert_not_equal(query_not_encode, query_encode)
  end
  test 'generate get correct url' do
    correct_url = create_url(2015)
    url_to_get = @controller.get_url( '20000','2015')
    assert_equal(correct_url, url_to_get)
  end

  test 'generate get nil url' do
    url_not_nil = @controller.get_url( '20202','2015')
    assert_not_nil(url_not_nil)
  end
  test 'exception parse json' do
    assert_raises(Exception) do
      data_json = '{"first_key",test wrong hash}'
      @controller.parse_json_to_hash(data_json)
    end
  end

  test 'correct parse json to ruby hash' do
    data_json = '{"first_key": [{"first_secondary":123},'\
                 '{"second_secondary":321},{"third":654}],'\
                 '"second_key": [{"first_secondary": "MarceloViado"}]}'

    data_hash = { 'first_key' => [{ 'first_secondary' => 123 },
                                  { 'second_secondary' => 321 }, { 'third' => 654 }],
                  'second_key' => [{ 'first_secondary' => 'MarceloViado' }] }

    json_changed = @controller.parse_json_to_hash(data_json)
    assert_equal(data_hash, json_changed)
  end

  test 'nil parse json to ruby hash' do
    data_json = '{"first_key": [{"first_secondary":123},'\
                 '{"second_secondary":321},{"third":654}],'\
                 '"second_key": [{"first_secondary": "MarceloViado"}]}'

    json_changed = @controller.parse_json_to_hash(data_json)

    assert_not_nil(json_changed)
  end

  test 'the get to API of budget' do
    create_fake_web
    FakeWeb.allow_net_connect = false
    public_agency_id = 20000
    year = 2013
    data_api = @controller.obtain_api_data(public_agency_id, year)
    # puts "#{data_api}"
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
    assert_not_empty data_api
  end

  test 'the fail connection with API of budget' do
    create_fake_web
    assert_raise(Exception) do
      FakeWeb.allow_net_connect = false
      year = 1000
      public_agency_id = 20000
      data_api = @controller.obtain_api_data(public_agency_id, year)
     # puts "#{data_api}"
    end
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end

  private

    def create_query(public_agency_id, year)
      year_query = ''
      if !year.nil?
        year_query = '?exercicioURI loa:identificador '+year+' . '
      end
      test_query =  'PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> '\
                    'PREFIX loa: <http://vocab.e.gov.br/2013/09/loa#>'\
                    'SELECT ?ano, (SUM(?valorProjetoLei) AS ?somaProjetoLei)'\
                    ' WHERE {?itemBlankNode loa:temExercicio ?exercicioURI . '\
                    +year_query+'?exercicioURI loa:identificador ?ano . '\
                    '?itemBlankNode loa:temUnidadeOrcamentaria ?uoURI . '\
                    '?uoURI loa:codigo "'+public_agency_id+'" . '\
                    '?itemBlankNode loa:valorProjetoLei ?valorProjetoLei . }'
      test_query
   end
    def create_fake_web
      for year in 2011..2014
        url = create_url(year)
        FakeWeb.register_uri(:get, url, body: '{"results":{"bindings":['\
          '{"ano": {"value":'+year.to_s+'},"somaProjetoLei":{"value":"1000"}}]}}')
      end
      url_query = create_url_all_years
      FakeWeb.register_uri(:get, url_query, body: '{"results":{"bindings":['\
          '{"ano": {"value": "2014"},"somaProjetoLei":{"value":"1000"}}]}}')
    end
    def create_url(year)
      url = 'http://aondebrasil.com:8890/sparql?default-graph-uri=&query='\
            'PREFIX%20rdf:%20%3Chttp://www.w3.org/1999/02/22-rdf-syntax-ns'\
            '%23%3E%20PREFIX%20loa:%20%3Chttp://vocab.e.gov.br/2013/09/loa'\
            '%23%3ESELECT%20?ano,%20(SUM(?valorProjetoLei)%20AS%20?somaProje'\
            'toLei)%20WHERE%20%7B?itemBlankNode%20loa:temExercicio%20?exercic'\
            'ioURI%20.%20?exercicioURI%20loa:identificador%20'+year.to_s+'%20'\
            '.%20?exercicioURI%20loa:identificador%20?ano%20.%20?itemBlankNod'\
            'e%20loa:temUnidadeOrcamentaria%20?uoURI%20.%20?uoURI%20loa:codig'\
            'o%20%2220000%22%20.%20?itemBlankNode%20loa:valorProjetoLei%20?va'\
            'lorProjetoLei%20.%20%7D&debug=on&timeout=&format=application%2Fs'\
            'parql-results%2Bjson&save=display&fname='
     end
    def create_url_all_years
      url = 'http://aondebrasil.com:8890/sparql?default-graph-uri=&query=PREFIX'\
            '%20rdf:%20%3Chttp://www.w3.org/1999/02/22-rdf-syntax-ns%23%3E%20PR'\
            'EFIX%20loa:%20%3Chttp://vocab.e.gov.br/2013/09/loa%23%3ESELECT%20?'\
            'ano,%20(SUM(?valorProjetoLei)%20AS%20?somaProjetoLei)%20WHERE%20%7'\
            'B?itemBlankNode%20loa:temExercicio%20?exercicioURI%20.%20?exercici'\
            'oURI%20loa:identificador%20?ano%20.%20?itemBlankNode%20loa:temUnid'\
            'adeOrcamentaria%20?uoURI%20.%20?uoURI%20loa:codigo%20%2220000%22%2'\
            '0.%20?itemBlankNode%20loa:valorProjetoLei%20?valorProjetoLei%20.%2'\
            '0%7D&debug=on&timeout=&format=application%2Fsparql-results%2Bjson&'\
            'save=display&fname='
     end

    def create_budget
      budget_hash = {"ano" => {"value" => "2011"},"somaProjetoLei" => {"value"=> "123456"}}
      return budget_hash
    end
end