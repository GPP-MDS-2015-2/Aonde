class BudgetControllerTest < ActionController::TestCase
  
  test "the budget query encode" do
    year = '2015'
    public_agency_id = '1'

    query_encode_expected = URI.encode(create_query(year,public_agency_id))
    puts "#{@controller.class}"
    query_encode = @controller.generate_query(year,public_agency_id)
    assert_equal(query_encode_expected, query_encode)
  end

  test "the budget query not encode" do
    year = '2011'
    public_agency_id = '2'
    query_not_encode = create_query(year,public_agency_id)
    query_encode = @controller.generate_query(year,public_agency_id)

    assert_not_equal(query_not_encode, query_encode)
  end

   def get_url(year, public_agency_id)
    begin_url = 'http://orcamento.dados.gov.br/sparql/?default-graph-uri=&query='

    end_url = '&debug=on&timeout=&format=application%2Fsparql-results%2Bjson'\
    '&save=display&fname='

    year = year.to_s
    public_agency_id = public_agency_id.to_s

    url_query = generate_query(year, public_agency_id)

    url = begin_url + url_query + end_url

    puts "\n\n\n\n#{url}\n\n\n"

    return url
  end

  test "generate get correct url" do
    correct_url = 'http://orcamento.dados.gov.br/sparql/?default-graph-uri=&query='\
    + URI.encode(create_query("2015","1")) +
    '&debug=on&timeout=&format=application%2Fsparql-results%2Bjson'\
    '&save=display&fname='
    method_url = @controller.get_url("2015","1")
    assert_equal(correct_url, method_url)
  end

  test "generate get nil url" do
    method_url = @controller.get_url("2015","1")
    assert_not_nil(method_url)
  end

  private
    def create_query(year,public_agency_id)
      test_query = 'SELECT (SUM(?ProjetoLei) AS ?somaProjetoLei) WHERE {'\
                    '?itemBlankNode loa:temExercicio ?exercicioURI . '\
                    '?exercicioURI loa:identificador '+year+' . '\
                    '?itemBlankNode loa:temUnidadeOrcamentaria ?uoURI . '\
                    '?uoURI loa:temOrgao ?orgaoURI . '\
                    '?orgaoURI loa:codigo "'+public_agency_id+'" . '\
                    '?itemBlankNode loa:valorProjetoLei ?ProjetoLei . }'
      return test_query
    end
end