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

	test "Should return a equals hashs" do
		hash = {"01/2015"=>0, "02/2015"=>0, "03/2015"=>0, "04/2015"=>0, "05/2015"=>0, "06/2015"=>0, "07/2015"=>0, "08/2015"=>0, "09/2015"=>0, "10/2015"=>0, "11/2015"=>0, "12/2015"=>0}
		hash_return = @controller.initialize_hash(2015)
		assert_equal(hash_return, hash)
	end

	test "Should return diferents hashs" do
		hash = {"01/2015"=>12, "02/2015"=>19, "03/2015"=>1, "04/2015"=>9, "05/2015"=>15, "06/2015"=>89, "07/2015"=>0, "08/2015"=>78, "09/2015"=>100, "10/2015"=>5, "11/2015"=>60, "12/2015"=>0}
		hash_return = @controller.initialize_hash(2015)
		assert_not_equal(hash_return, hash)
	end

	
end

