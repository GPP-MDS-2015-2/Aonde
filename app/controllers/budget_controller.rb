class Budget < ApplicationController

  def generate_query(year,code_public_agency)

  	query = "SELECT (SUM(?ProjetoLei) AS ?somaProjetoLei) WHERE {"+
    "?itemBlankNode loa:temExercicio ?exercicioURI . "+
    "?exercicioURI loa:identificador "+year+" . "+
    "?itemBlankNode loa:temUnidadeOrcamentaria ?uoURI . "+
    "?uoURI loa:temOrgao ?orgaoURI . "+
    "?orgaoURI loa:codigo "+code_public_agency+" . "+
    "?itemBlankNode loa:valorProjetoLei ?ProjetoLei . }"

    url_query = URI.encode(query)
    
    return url_query
  end

  def get_url(year,code_public_agency)
    year = year.to_s
    code_public_agency.to_s
    code_public_agency = code_public_agency.to_s

    begin_url = "http://orcamento.dados.gov.br/sparql/?default-graph-uri=&query="

    end_url = "&debug=on&timeout=&format=application%2Fsparql-results%2Bjson&save=display&fname="

    url_query = generate_query(year,code_public_agency)

    url = begin_url+url_query+end_url

    puts "\n\n\n\n#{url}\n\n\n"

    return url
  end

  def get_api_data(year,code_public_agency)
    data = Net::HTTP.get(URI.parse(get_url(year,code_public_agency)))
    puts "#{data}"
    return data
  end

end