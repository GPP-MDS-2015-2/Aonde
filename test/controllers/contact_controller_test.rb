require 'test_helper'

class ContactControllerTest < ActionController::TestCase
	test 'Should redirect to home' do
		post :send_simple_message, from: "test@email.com", subject: "subject", text: "Text"
		assert_response :redirect
		assert_redirected_to root_path	
	end

	test 'Should not have all params' do
		assert_raise(Exception) { 
			@controller.send_simple_message
		}
    end
end