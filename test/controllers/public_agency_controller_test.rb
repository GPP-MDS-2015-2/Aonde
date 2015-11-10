require 'test_helper'

class PublicAgencyControllerTest < ActionController::TestCase
  
  test "should get public_agencies" do

    get :index
    assert_response :success
    assert_not_nil assigns(:public_agencies)
    assert_equal(assigns(:public_agencies).ids,[], msg=nil)
  end
    
end
