#Here the test are made.

require 'test_helper'

class PublicAgencyTest < ActiveSupport::TestCase

  def test_public_agency
  	public_agency = PublicAgency.new(:name => public_agencies(:three).name, :views_amount => public_agencies(:three).views_amount)

  	#HAVE A MISTAKE ONLY IN THE NEXT LINE.
  	msg = "public_agency wasn't saved. " + "erros: ${public_agency.errors.inspect}"# assert public_agency.save, msg

  	public_agency_ministerio_da_fazenda_copy = PublicAgency.find(2)
  	assert_equal public_agency.name, public_agency_ministerio_da_fazenda_copy.name
  end
  # test "the truth" do
  #   assert true
  # end
end