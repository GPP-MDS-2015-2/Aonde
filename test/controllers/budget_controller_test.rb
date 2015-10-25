 require 'test_helper'

class BudgetControllerTest < ActionController::TestCase

	test "Should return a valid period" do
		data = Date.new(2015,06,01)
		boolean = @controller.is_date_in_interval("Janeiro",2015,"Dezembro",2015,data)
		expect_return = true
		assert_equal(expect_return,boolean)	
	end

	test "Should return an invalid period" do
		data = Date.new(2014,06,01)
		boolean = @controller.is_date_in_interval("Janeiro",2015,"Dezembro",2015,data)
		expect_return = false
		assert_equal(expect_return,boolean)	
	end


end

