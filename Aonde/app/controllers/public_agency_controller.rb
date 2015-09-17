class PublicAgencyController < ApplicationController
	def index
		@pb_agencies = PublicAgency.all
	end
end
