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

end