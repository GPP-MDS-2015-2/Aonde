require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
	
	test "Should return 2015 if params[:year] is nil" do
		year = "2015"
		params_nil = {}
		year_return = @controller.initialize_year(params_nil)

		assert_equal(year,year_return)
	end

	test "Should find public agency" do
		create_entities
		@controller.find_agencies(1)
		assert assigns(:public_agency) 
	end


	test "Should find superior public agency" do
		create_entities
		@controller.find_agencies(1)
		assert assigns(:superior_public_agency) 
	end

	def create_entities
		SuperiorPublicAgency.create(id: 1, name: 'valid SuperiorPublicAgency')
   		PublicAgency.create(id: 1, views_amount: 0, name: 'valid Agency', superior_public_agency_id: 1)
	end 
end