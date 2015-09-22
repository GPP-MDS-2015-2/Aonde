class PublicAgencyController < ApplicationController

	def index

		@public_agencies = PublicAgency.all

		@public_agency_grid = initialize_grid(PublicAgency,
			order: 'public_agencies.views_amount',
      		order_direction: 'desc',
      		per_page: 10
        )

	end

	def show

		@public_agency = PublicAgency.find(params[:id])
		@superior_public_agency = SuperiorPublicAgency.find(@public_agency.superior_public_agency_id)

	end

end
