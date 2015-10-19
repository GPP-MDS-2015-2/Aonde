require 'test_helper'

class CompanyControllerTest < ActionController::TestCase

	test "Route to method show and the result of the request" do

		generate_public_agency
		assert_routing 'public_agency/1/company', { :controller => "company", :action => "show", :id => "1" }
		get :show, id: 1
		assert_response :success

	end

	def generate_public_agency

		PublicAgency.create(id: 1,views_amount: 0,name: "valid Agency")
		
	end	

	test "should return a ordered hash" do

		hash = {"key1"=>12,"key2"=>8,"key3"=>10}
		hash = @controller.sort_by_expense(hash)
		ordered_hash = {"key2"=>8,"key3"=>10,"key1"=>12}.to_a
		assert_equal(hash,ordered_hash)

	end

end

