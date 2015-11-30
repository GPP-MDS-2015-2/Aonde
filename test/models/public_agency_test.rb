#Here the test are made.
=begin
require 'test_helper'

class PublicAgencyTest < ActiveSupport::TestCase

#Testing save operation on model of program
  def test_save_name_nil
    public_agency = PublicAgency.new(:name => public_agencies(:name_nil).name, :views_amount => public_agencies(:name_nil).views_amount)

    assert_not public_agency.valid?
    assert_not public_agency.save
  end

  def test_save_views_amount_negative
    public_agency = PublicAgency.new(:name => public_agencies(:negative_number).name, :views_amount => public_agencies(:negative_number).views_amount)

    assert_not public_agency.valid?
    assert_not public_agency.save
  end

  def test_save_views_wrong_way
    public_agency = PublicAgency.new(:name => public_agencies(:wrong).name, :views_amount => public_agencies(:wrong).views_amount)

    assert_not public_agency.valid?
    assert_not public_agency.save
  end


  def test_save_correct_way
    public_agency = PublicAgency.new(:name => public_agencies(:correct).name, :views_amount => public_agencies(:correct).views_amount)

    assert public_agency.valid?
    assert public_agency.save
  end
end
=end