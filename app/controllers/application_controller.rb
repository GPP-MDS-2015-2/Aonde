class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
#  before_action :owl_zueira

 # def owl_zueira
  #  logger.info "  ,,,\n {0,0}\n./) )\n==\"=\"=="
    #sleep(1)
  #end

  def find_agencies(id=0)
    @public_agency = PublicAgency.find(id)
    @superior_public_agency = SuperiorPublicAgency
    .find(@public_agency.superior_public_agency_id)
  end
end
