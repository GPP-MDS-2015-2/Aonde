#Here the test are made.

require 'test_helper'

class PublicAgencyTest < ActiveSupport::TestCase

  def test_public_agency_save
  	public_agency = PublicAgency.new(:name => public_agencies(:three).name, :views_amount => public_agencies(:three).views_amount)

    #assert_not public_agency.valid?
    assert public_agency.valid?
    assert public_agency.save
  end
end