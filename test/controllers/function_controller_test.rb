require 'test_helper'

class FunctionControllerTest < ActionController::TestCase
	
	test "Should validate atributtes" do

		@controller.insert_expenses_functions
		assert_nil(@function)
		
	end

	test "Route to method show" do

		assert_routing '/functions', { :controller => "function", :action => "show" }	
		get :show

		assert_response :success
	end

	test "Should convert to a hash" do

		hash_to_json = [{"key1"=>1},{"key2"=>2}].to_json
		expected_hash = [{"key1"=>1},{"key2"=>2}]
		returned_hash = @controller.convert_to_a_hash(hash_to_json)
		assert_equal(expected_hash,returned_hash)

	end

	test "Should filter datas" do

		hash_json = [{"id"=>nil,"description"=>"Saúde","sumValue"=>2}]
		expected_hash = {"Saúde"=>2}		
		returned_hash = @controller.filter_datas_in_expense(hash_json)
		assert_equal(expected_hash,returned_hash)

	end

	test "Should return the last day of month" do

		month_number = 1
		last_day = @controller.find_month_limit(month_number)
		expected_last_day = 31
		assert_equal(expected_last_day,last_day)

	end

	test "should return the last day of month" do

		month_number = 4
		last_day = @controller.find_month_limit(month_number)
		expected_last_day = 30
		assert_equal(expected_last_day,last_day)

	end


	test "should return the last day of month" do

		month_number = 2
		last_day = @controller.find_month_limit(month_number)
		expected_last_day = 28
		assert_equal(expected_last_day,last_day)

	end

end