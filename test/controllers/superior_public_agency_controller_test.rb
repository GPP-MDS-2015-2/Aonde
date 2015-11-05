require 'test_helper'

class SuperiorPublicAgencyControllerTest < ActionController::TestCase

	test "Routes to method show" do
		create_entities

		get :show, id: 1

		assert_response :success

		assert assigns(:superior_agency)
		assert assigns(:data_superior_agency)

	end

	def create_entities
		SuperiorPublicAgency.create(id: 1,name: "valid SuperiorPublicAgency")
	end

end
