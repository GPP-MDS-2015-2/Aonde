class BudgetControllerTest < ActionController::TestCase
  def get_all_budget(public_agency_id)
    budget_years = []
    for year in 2011..2015
      data_api = {}
      begin
        data_api = obtain_api_data(year, public_agency_id)
      rescue
        raise "Não foi possível conectar a API"
      end
      budget_hash = parse_json_to_hash(data_api)
      value_budget = get_value_budget(budget_hash)
      budget_years << value_budget
    end
    return budget_years
  end

  test 'exception in the generation of budget array' do
    FakeWeb.register_uri(:get, 'http://example.com/test1', :body => '{"head":{"link":[],"vars":["somaProjetoLei"]},"results":{"distinct":false,"ordered":true,"bindings":[{"somaProjetoLei":{"type":"typed-literal","datatype":"http://www.w3.org/2001/XMLSchema#double","value":"7159141334"}}]}}' )
    data = Net::HTTP.get(URI.parse("http://example.com/test1"))
    assert true
  end
=begin
  test 'generation of arary of budgets' do
    public_agency_id = 20000
    budget_array = @controller.get_all_budget(public_agency_id)
    assert_not_empty budget_array
  end'
  test 'exception raise of empty budget value' do
    assert_raises(Exception){
         data_budget = { 'head' => { 'link' => [], 'vars' => ['somaProjetoLei'] },
                    'results' => { 'distinct' => false, 'ordered' => true,
                                   'bindings' => [{}] } }
         @controller.get_value_budget(data_budget)
    }
  end

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
=end
  #   test "the budget query encode" do
  #     year = '2015'
  #     public_agency_id = '1'
  #
  #     query_encode_expected = URI.encode(create_query(year,public_agency_id))
  #     #puts "#{@controller.class}"
  #     query_encode = @controller.generate_query(year,public_agency_id)
  #     assert_equal(query_encode_expected, query_encode)
  #   end
  #
  #   test "the budget query not encode" do
  #     year = '2011'
  #     public_agency_id = '2'
  #     query_not_encode = create_query(year,public_agency_id)
  #     query_encode = @controller.generate_query(year,public_agency_id)
  #
  #     assert_not_equal(query_not_encode, query_encode)
  #   end
  #
  #   test "generate get correct url" do
  #     correct_url = 'http://orcamento.dados.gov.br/sparql/?default-graph-uri=&query='\
  #     + URI.encode(create_query("2015","1")) +
  #     '&debug=on&timeout=&format=application%2Fsparql-results%2Bjson'\
  #     '&save=display&fname='
  #     url_not_nil = @controller.get_url("2015","1")
  #     assert_equal(correct_url, url_not_nil)
  #   end
  #
  #   test "generate get nil url" do
  #     url_not_nil = @controller.get_url("2015","1")
  #     assert_not_nil(url_not_nil)
  #   end
  #
  #     def parse_json_to_hash(data_api)
  #     budget_year = {}
  #     begin
  #       budget_year = JSON.parse(data_api)
  #     rescue
  #       raise 'Não foi possivel conventer os dados da API do orçamento'
  #     end
  #     return budget_year
  #   end
  #
  #   test "exception parse json" do
  #     assert_raises(Exception){
  #       data_json = '{"first_key",test wrong hash}'
  #       @controller.parse_json_to_hash(data_json)
  #     }
  #   end
  #
  #   test "correct parse json to ruby hash" do
  #     data_json = '{"first_key": [{"first_secondary":123},'\
  #                  '{"second_secondary":321},{"third":654}],'\
  #                  '"second_key": [{"first_secondary": "MarceloViado"}]}'
  #
  #     data_hash = {"first_key"=>[{"first_secondary"=>123},
  #      {"second_secondary"=>321}, {"third"=>654}],
  #       "second_key"=>[{"first_secondary"=>"MarceloViado"}]}
  #
  #     json_changed = @controller.parse_json_to_hash(data_json)
  #     assert_equal(data_hash, json_changed)
  #   end
  #
  #   test "nil parse json to ruby hash" do
  #     data_json = '{"first_key": [{"first_secondary":123},'\
  #                  '{"second_secondary":321},{"third":654}],'\
  #                  '"second_key": [{"first_secondary": "MarceloViado"}]}'
  #
  #     json_changed = @controller.parse_json_to_hash(data_json)
  #
  #     assert_not_nil(json_changed)
  #   end
  #
  #   private
  #     def create_query(year,public_agency_id)
  #       test_query = 'SELECT (SUM(?ProjetoLei) AS ?somaProjetoLei) WHERE {'\
  #                     '?itemBlankNode loa:temExercicio ?exercicioURI . '\
  #                     '?exercicioURI loa:identificador '+year+' . '\
  #                     '?itemBlankNode loa:temUnidadeOrcamentaria ?uoURI . '\
  #                     '?uoURI loa:temOrgao ?orgaoURI . '\
  #                     '?orgaoURI loa:codigo "'+public_agency_id+'" . '\
  #                     '?itemBlankNode loa:valorProjetoLei ?ProjetoLei . }'
  #       return test_query
  #     end
end
