class SuperiorPublicAgencyController < ApplicationController
	def show
		@superior_agency = SuperiorPublicAgency.find(params[:id])
	end

	def find_public_agencies(superior_id)
		public_agencies = PublicAgency.where(superior_public_agency_id: superior_id)
	end

end
