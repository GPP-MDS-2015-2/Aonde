require 'test_helper'

class PublicAgencyHelperTest < ActionView::TestCase
include PublicAgencyHelper
=begin
public void testfacebook_share_amout() {
	assertEquals(0, facebook_share_amount("http://aondebrasil.com"+ public_agency_path(@public_agency.id)
}
=end

test "Route to facebook" do
	url = 'http://graph.facebook.com/?ids=http://aondebrasil.com/'\
	'public_agency/20101'
	FakeWeb.allow_net_connect = false
	FakeWeb.register_uri(:get, url, body: 
		{'http://aondebrasil.com/public_agency/20101' => {}}.to_json)
	x = facebook_share_amount("http://aondebrasil.com" + public_agency_path(20101))
	assert_equal(0,x)
	FakeWeb.allow_net_connect = true
end

test "Not route to facebook" do
	url = 'http://graph.facebook.com/?ids=http://aondebrasil.com/'\
	'public_agency/20101'
	FakeWeb.allow_net_connect = false
	FakeWeb.register_uri(:get, url, body: 
		{'http://aondebrasil.com/public_agency/20101' => {'shares'=>123}}.to_json)
	x = facebook_share_amount("http://aondebrasil.com" + public_agency_path(20101))
	assert_equal(123,x)
	FakeWeb.allow_net_connect = true
end

end