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

	test "Should return a not empty filter" do
		
		list_type_expenses = [1, 2, 3, 4, 5, 6]
		not_empty_list = @controller.is_empty_filter(list_type_expenses)
		assert_not (not_empty_list)
		
	end

	test "Should return a empty filter" do
		list_type_expenses = []
		empty_list = @controller.is_empty_filter(list_type_expenses)
		assert (empty_list)
	end


end

