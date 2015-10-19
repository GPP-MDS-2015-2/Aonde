require 'test_helper'
require 'database_cleaner'
=begin
class PublicAgencyControllerTest < ActionController::TestCase
 	
 	DatabaseCleaner.strategy = :truncation	

	test "should get public_agencies" do
		DatabaseCleaner.clean
		get :index
		assert_response :success
		assert_not_nil assigns(:public_agencies)
		assert_equal(assigns(:public_agencies).ids,[], msg=nil)
	end
		
end
=end