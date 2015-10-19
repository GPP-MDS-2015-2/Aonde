require 'test_helper'

class CompanyControllerTest < ActionController::TestCase
	test "Route to method show and the result of the request" do

		generate_public_agency
		assert_routing 'public_agency/1/company', { :controller => "company", :action => "show", :id => "1" }
		get :show, id: 1
		assert_response :success
		assert_not_nil assigns(:array_companies_expenses)
		assert assigns(:array_companies_expenses)

	end

	def generate_public_agency

		PublicAgency.create(id: 1,views_amount: 0,name: "valid Agency")
		
	end	

end

