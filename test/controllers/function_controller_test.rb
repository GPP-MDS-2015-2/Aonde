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

end