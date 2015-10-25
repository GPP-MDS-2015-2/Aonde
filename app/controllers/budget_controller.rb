class BudgetController < ApplicationController
  def get_api_data(public_agency_id)
    budget_years = []
    begin
      budget_years = get_all_budget(public_agency_id)
      puts budget_years
    rescue Exception => error
      budget_years = error
      puts error
    end

    return budget_years
  end

  def get_all_budget(public_agency_id)
    budget_years = []
    for year in 2011..2013
      data_api = obtain_api_data(year, public_agency_id)
      budget_hash = parse_json_to_hash(data_api)
      value_budget = get_value_budget(budget_hash)
      budget_years << { year => value_budget }
    end
    return budget_years
  end

  def obtain_api_data(year, public_agency_id)
    data_api = ""
    begin
      url_query = get_url(year, public_agency_id)
      uri_query = URI.parse(url_query)
      data_api = Net::HTTP.get(uri_query)
    rescue
        raise "Não foi possível conectar a API"
    end
    return data_api
  end

  def get_value_budget(budget_hash)
    value = 0
    value_budget_hash = budget_hash['results']['bindings'][0]

    # Verify if the result of the API has the value of budget
    if !value_budget_hash.empty?
      value = value_budget_hash['somaProjetoLei']['value']
    else
      raise "Não foi possível obter o valor do orçamento pela api"
    end

    return value
  end

  def parse_json_to_hash(data_api)
    budget_year = {}
    begin
      budget_year = JSON.parse(data_api)
    rescue
      raise 'Não foi possivel conventer os dados da API do orçamento'
    end
    return budget_year
  end

  def get_url(year, public_agency_id)
    begin_url = 'http://orcamento.dados.gov.br/sparql/?default-graph-uri=&query='

    end_url = '&debug=on&timeout=&format=application%2Fsparql-results%2Bjson'\
    '&save=display&fname='

    year = year.to_s
    public_agency_id = public_agency_id.to_s

    url_query = generate_query(year, public_agency_id)

    url = begin_url + url_query + end_url

    #puts "\n\n\n\n#{url}\n\n\n"

    return url
  end

  def generate_query(year, public_agency_id)
    query = 'SELECT (SUM(?ProjetoLei) AS ?somaProjetoLei) WHERE {'\
    '?itemBlankNode loa:temExercicio ?exercicioURI . '\
    '?exercicioURI loa:identificador ' + year + ' . '\
    '?itemBlankNode loa:temUnidadeOrcamentaria ?uoURI . '\
    '?uoURI loa:temOrgao ?orgaoURI . '\
    '?orgaoURI loa:codigo "' + public_agency_id + '" . '\
    '?itemBlankNode loa:valorProjetoLei ?ProjetoLei . }'

    url_query = URI.encode(query)

    return url_query
  end
end
