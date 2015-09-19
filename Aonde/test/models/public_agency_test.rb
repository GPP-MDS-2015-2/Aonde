#Here the test are made.

require 'test_helper'

class PublicAgencyTest < ActiveSupport::TestCase

  def assertation(public_agency)
    assert public_agency.valid?
    assert public_agency.save
  end

  def test_save_name_nil
    public_agency = PublicAgency.new(:name => public_agencies(:number).name, :views_amount => public_agencies(:number).views_amount)

    assertation(public_agency)
  end

  def test_save_views_amount_negative
    public_agency = PublicAgency.new(:name => public_agencies(:two).name, :views_amount => public_agencies(:two).views_amount)

    assertation(public_agency)
  end

  def test_save_views_wrong_way
    public_agency = PublicAgency.new(:name => public_agencies(:three).name, :views_amount => public_agencies(:three).views_amount)

    assertation(public_agency)
  end


  def test_save_correct_way
    public_agency = PublicAgency.new(:name => public_agencies(:four).name, :views_amount => public_agencies(:four).views_amount)

    assertation(public_agency)
  end
end