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