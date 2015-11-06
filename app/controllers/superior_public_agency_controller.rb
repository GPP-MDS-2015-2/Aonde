class SuperiorPublicAgencyController < ApplicationController
	def show
		@superior_agency = SuperiorPublicAgency.find(params[:id])
		public_agencies = find_public_agencies(@superior_agency.id)
		@data_superior_agency = Graph.create_nodes_superior(@superior_agency, public_agencies)
		@data_superior_agency = @data_superior_agency.to_json
	end

	def find_public_agencies(superior_id)
		public_agencies = PublicAgency.where(superior_public_agency_id: superior_id)
	end

	

end
