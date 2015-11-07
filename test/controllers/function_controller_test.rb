require 'test_helper'

class FunctionControllerTest < ActionController::TestCase

	test "Should validate atributtes" do

		@controller.insert_expenses_functions(2015,2015,1,12,1,31)
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


	test "Should not convert to a hash" do

		hash = [{"key1"=>1},{"key2"=>2}].to_json
		expected_hash = {{"key1"=>1}=>{"key2"=>2}}
		returned_hash = @controller.convert_to_a_hash(hash)
		assert_not_equal(expected_hash,returned_hash)

	end

	test "Should filter datas" do

		hash_json = [{"id"=>nil,"description"=>"Saúde","sumValue"=>2}]
		expected_hash = {"Saúde"=>2}		
		returned_hash = @controller.filter_datas_in_expense(hash_json)
		assert_equal(expected_hash,returned_hash)

	end

	test "Should return the last day of month,first case" do

		month_number = 1
		last_day = @controller.find_month_limit(month_number)
		expected_last_day = 31
		assert_equal(expected_last_day,last_day)

	end

	test "Should return the last day of month,second case" do

		month_number = 4
		last_day = @controller.find_month_limit(month_number)
		expected_last_day = 30
		assert_equal(expected_last_day,last_day)

	end

	test "Should return the n first elements of a hash" do
		hash_with_11 = {a: 1,b: 2,c: 3,d: 4,e: 5,f: 6,g: 7,h: 8,i: 9,j: 10,i: 11}
		
		hash_result = @controller.filter_top_n(hash_with_11,4)
		hash_with_4 = {a: 1,b: 2,c: 3,d: 4}
		assert_equal(hash_result,hash_with_4)

	end

	test "Should return the hash if its length < n" do
		hash_with_2 = {a: 1,b: 2}
		
		hash_result = @controller.filter_top_n(hash_with_2,900)
		assert_equal(hash_result,hash_with_2)

	end 
	
	test "Should return empty hash" do 

		hash_empty = {}

		hash_result = @controller.filter_top_n(hash_empty,4)
		assert_equal(hash_result,hash_empty)

	end

	test "Should return the last day of month,third case" do

		month_number = 2
		last_day = @controller.find_month_limit(month_number)
		expected_last_day = 28
		assert_equal(expected_last_day,last_day)

	end




end