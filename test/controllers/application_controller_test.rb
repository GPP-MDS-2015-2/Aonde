require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
	
	test "Should return 2015 if params[:year] is nil" do
		year = "2015"
		params_nil = {}
		year_return = @controller.initialize_year(params_nil)

		assert_equal(year,year_return)
	end

end