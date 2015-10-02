require 'test_helper'

class SuperiorPublicAgencyTest < ActiveSupport::TestCase
  
  def test_save_name_nil
  	superior_public_agency = SuperiorPublicAgency.new(:name => superior_public_agencies(:name_nil).name)

  	assert_not superior_public_agency.valid?
  	assert_not superior_public_agency.save
  end

  def test_save_correct
  	superior_public_agency = SuperiorPublicAgency.new(:name => superior_public_agencies(:correct).name)

  	assert superior_public_agency.valid?
  	assert superior_public_agency.save
  end

end
