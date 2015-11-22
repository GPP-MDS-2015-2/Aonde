require 'test_helper'

class ContactControllerTest < ActionController::TestCase
	# test 'should have all params in post' do
	# 	assert_true(true)
	# end

	test 'Should redirect to home' do
		post :send_simple_message, from: "test@email.com", subject: "subject", text: "Text"

		assert_response :redirect

		assert_redirected_to root_path	
	end
end