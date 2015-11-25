class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :owl_zueira

  def owl_zueira
    logger.info "  ,,,\n {0,0}\n./) )\n==\"=\"=="
    #sleep(1)
  end

  #create a hash to convert a name of month to int
  def month_to_int(month)
  
    conversion_data = {}
    conversion_data['Janeiro'] = 1
    conversion_data['Fevereiro'] = 2
    conversion_data['Março'] = 3
    conversion_data['Abril'] = 4
    conversion_data['Maio'] = 5
    conversion_data['Junho'] = 6
    conversion_data['Julho'] = 7
    conversion_data['Agosto'] = 8
    conversion_data['Setembro'] = 9
    conversion_data['Outubro'] = 10
    conversion_data['Novembro'] = 11
    conversion_data['Dezembro'] = 12
    conversion_data['Todos'] = 0

    return conversion_data[month]
  end

  def find_agencies(id=0)
    @public_agency = PublicAgency.find(id)
    @superior_public_agency = SuperiorPublicAgency
    .find(@public_agency.superior_public_agency_id)
  end
end
