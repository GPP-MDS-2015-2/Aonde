class BudgetController < ApplicationController
  def get_api_data(year, code_public_agency)
    budget_years = []
    begin
      data = Net::HTTP.get(URI.parse(get_url(year, code_public_agency)))
      budget_hash = parse_json_to_hash(data)
      value_budget = get_value_budget(budget_hash)
      budget_years << value_budget
    rescue Exception => error
      puts '#{error}'
    end

    return budget_years
  end

  def get_value_budget(budget_hash)
    value = 0
    sum_total_budget = budget_hash['results']['bindings'][0]

    # Verify if the result of the API has the value of budget
    if !sum_total_budget.empty?
      value = sum_total_budget['somaProjetoLei']['value']
    else
      fail 'Não foi possível obter o valor do orçamento pela api'
    end

    return value
  end

  def parse_json_to_hash(data)
    budget_year = {}
    begin
      budget_year = JSON.parse(data)
    rescue
      raise 'Não foi possivel conventer os dados da API do orçamento'
    end
    return budget_year
  end

  def get_url(year, code_public_agency)
    begin_url = 'http://orcamento.dados.gov.br/sparql/?default-graph-uri=&query='

    end_url = '&debug=on&timeout=&format=application%2Fsparql-results%2Bjson'\
    '&save=display&fname='

    year = year.to_s
    code_public_agency.to_s
    code_public_agency = code_public_agency.to_s

    url_query = generate_query(year, code_public_agency)

    url = begin_url + url_query + end_url

    puts '\n\n\n\n#{url}\n\n\n'

    return url
  end

  def generate_query(year, code_public_agency)
    query = 'SELECT (SUM(?ProjetoLei) AS ?somaProjetoLei) WHERE {'\
    '?itemBlankNode loa:temExercicio ?exercicioURI . '\
    '?exercicioURI loa:identificador ' + year + ' . '\
    '?itemBlankNode loa:temUnidadeOrcamentaria ?uoURI . '\
    '?uoURI loa:temOrgao ?orgaoURI . '\
    '?orgaoURI loa:codigo "' + code_public_agency + '" . '\
    '?itemBlankNode loa:valorProjetoLei ?ProjetoLei . }'

    url_query = URI.encode(query)

    return url_query
  end
end
