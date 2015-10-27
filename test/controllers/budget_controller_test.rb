class BudgetControllerTest < ActionController::TestCase
test "get url" do
  x=@controller.get_budget(20101)
  puts x
  assert true
end
=begin  
######################################################
change the name method get_all_budget to get_budget
######################################################
  test 'the empty return result of budgets' do
    not_exist_id = -1
    budget_epmty = @controller.get_all_budget(not_exist_id)
    assert_empty budget_epmty
  end

  test 'the budgets not null' do
    create_fake_web
    budgets_not_nil = @controller.get_all_budget(20_000)
    FakeWeb.clean_registry
    assert_not_nil(budgets_not_nil)
  end

  test 'exception in the generation of budget array' do
    create_fake_web
    budgets_by_year = @controller.get_all_budget(20_000)
    expected_budgets = [{ 2011 => '7159141334' }, { 2012 => '7159141334' }, { 2013 => '7159141334' }]
    FakeWeb.clean_registry
    assert assert_equal(expected_budgets, budgets_by_year)
  end
  test 'generation of arary of budgets' do
    create_fake_web
    public_agency_id = 20_000
    budget_array = @controller.get_all_budget(public_agency_id)
    FakeWeb.clean_registry
    assert_not_empty budget_array
  end

  test 'the return erros in the result of budgets' do
    not_exist_id = -1
    budget_epmty = @controller.get_all_budget(not_exist_id)
    assert_empty budget_epmty
  end
######################################################
=end
=begin
######################################################
change the name method get_value_budget to valid_data?
######################################################
  test 'exception raise of empty budget value' do
    assert_raises(Exception) do
      data_budget = { 'head' => { 'link' => [], 'vars' => ['somaProjetoLei'] },
                      'results' => { 'distinct' => false, 'ordered' => true,
                                     'bindings' => [{}] } }
      @controller.get_value_budget(data_budget)
    end
  end
###########################################################
  test 'extract the value of budget' do
    data_budget = { 'head' => { 'link' => [], 'vars' => ['somaProjetoLei'] },
                    'results' => { 'distinct' => false, 'ordered' => true,
                                   'bindings' => [{ 'somaProjetoLei' =>
                                    { 'type' => 'typed-literal',
                                      'datatype' => 'http://www.w3.org/2001/'\
                                      'XMLSchema#double',
                                      'value' => '7159141334' } }] } }
    value = '7159141334'

    value_hash = @controller.get_value_budget(data_budget)

    assert_equal(value, value_hash)
  end
##############################################################
=end
  test 'the budget query encode' do
    year = '2015'
    public_agency_id = '1'

    query_encode_expected = URI.encode(create_query(year, public_agency_id))
    # puts "#{@controller.class}"
    query_encode = @controller.generate_query(year, public_agency_id)
    assert_equal(query_encode_expected, query_encode)
  end

  test 'the budget query not encode' do
    year = '2011'
    public_agency_id = '2'
    query_not_encode = create_query(year, public_agency_id)
    query_encode = @controller.generate_query(year, public_agency_id)

    assert_not_equal(query_not_encode, query_encode)
  end

  test 'generate get correct url' do
    correct_url = 'http://orcamento.dados.gov.br/sparql/?default-graph-uri='\
    '&query=' + URI.encode(create_query('2015', '1')) +
      '&debug=on&timeout=&format=application%2Fsparql-results%2Bjson'\
      '&save=display&fname='
    url_not_nil = @controller.get_url('2015', '1')
    assert_equal(correct_url, url_not_nil)
  end

  test 'generate get nil url' do
    url_not_nil = @controller.get_url('2015', '1')
    assert_not_nil(url_not_nil)
  end


  test 'the get to API of budget' do
    create_fake_web
    public_agency_id = 20_000
    year = 2013
    data_api = @controller.obtain_api_data(year, public_agency_id)
    # puts "#{data_api}"
    FakeWeb.clean_registry
    assert_not_empty data_api
  end

  test 'the fail connection with API of budget' do
    create_fake_web
    assert_raise(Exception) do
      FakeWeb.allow_net_connect = false
      year = 2014
      public_agency_id = 20_000
      data_api = @controller.obtain_api_data(year, public_agency_id)
      puts "#{data_api}"
    end
    FakeWeb.clean_registry
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

  private

    def create_query(year, public_agency_id)
      test_query = 'SELECT (SUM(?ProjetoLei) AS ?somaProjetoLei) WHERE {'\
                    '?itemBlankNode loa:temExercicio ?exercicioURI . '\
                    '?exercicioURI loa:identificador ' + year + ' . '\
                    '?itemBlankNode loa:temUnidadeOrcamentaria ?uoURI . '\
                    '?uoURI loa:temOrgao ?orgaoURI . '\
                    '?orgaoURI loa:codigo "' + public_agency_id + '" . '\
                    '?itemBlankNode loa:valorProjetoLei ?ProjetoLei . }'
      test_query
   end

  def create_fake_web
    for year in 2011..2014
      url = 'http://orcamento.dados.gov.br/sparql/'\
      '?default-graph-uri=&query=SELECT%20(SUM(?ProjetoLei)%20AS%20'\
      '?somaProjetoLei)%20WHERE%20%7B?itemBlankNode%20loa:temExercicio%20'\
      '?exercicioURI%20.%20?exercicioURI%20loa:identificador%20'+ year.to_s +
        '%20.%20?itemBlankNode%20loa:temUnidadeOrcamentaria%20'\
        '?uoURI%20.%20?uoURI%20loa:temOrgao%20?orgaoURI%20.%20'\
        '?orgaoURI%20loa:codigo%20%2220000%22%20.%20'\
        '?itemBlankNode%20loa:valorProjetoLei%20'\
        '?ProjetoLei%20.%20%7D&debug=on&timeout=&format=application%2Fsparql'\
        '-results%2Bjson&save=display&fname='
      FakeWeb.register_uri(:get, url, body: '{"head":{"link":[],"vars":'\
        '["somaProjetoLei"]},"results":{"distinct":false,"ordered":true,'\
        '"bindings":[{"somaProjetoLei":{"type":"typed-literal","datatype":'\
        '"http://www.w3.org/2001/XMLSchema#double",'\
        '"value":"7159141334"}}]}}')
    end
  end
end
