require 'test_helper'

class FunctionControllerTest < ActionController::TestCase
	

	test "Should convert to a hash" do

		hash_to_json = [{"key1"=>1},{"key2"=>2}].to_json
		expected_hash = [{"key1"=>1},{"key2"=>2}]
		returned_hash = @controller.convert_to_a_hash(hash_to_json)
		assert_equal(expected_hash,returned_hash)

	end

end