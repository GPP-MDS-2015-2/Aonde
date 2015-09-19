class PublicAgencyController < ApplicationController
	def index
		@public_agencies = PublicAgency.all
	end
end
