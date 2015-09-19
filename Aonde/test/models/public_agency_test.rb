#Here the test are made.

require 'test_helper'

class PublicAgencyTest < ActiveSupport::TestCase

  def test_public_agency
  	public_agency = Public_agency.new(:name => public_agencies(:ministerio_da_fazenda).name, :views_amount => public_agencies(:ministerio_da_fazenda).views_amount)

  	#HAVE A MISTAKE ONLY IN THE NEXT LINE.
  	msg = "public_agency wasn't saved. " + "erros: ${public_agency.errors.inspect}" assert public_agency.save, msg

  	public_agency_ministerio_da_fazenda_copy = Public_agency.find(public_agency.id)
  	assert_equal public_agency.name, public_agency_ministerio_da_fazenda_copy.name
  end
  # test "the truth" do
  #   assert true
  # end
end