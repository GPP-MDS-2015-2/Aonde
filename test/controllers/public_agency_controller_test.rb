require 'test_helper'

class PublicAgencyControllerTest < ActionController::TestCase
  # called before every single test
  def setup
    FakeWeb.allow_net_connect = false
    create_fake_facebook
    clean_database
    create_public_agency
  end

  # called after every single test
  def teardown
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = true
  end
  #
  test 'get index of public agencies' do
    get :index
    assert_response :success
    assert_not_nil assigns(:public_agencies)
    assert_not_nil assigns(:total_expense_agency)
  end

  test 'get show public agency' do
    create_public_agency
    get :show, id: 1
    assert_response :success
  end

  test 'increment one unit in views amount' do
    public_agency = PublicAgency.find(1)
    @controller.send(:increment_views_amount, public_agency)
    assert_equal(2, public_agency.views_amount)
  end

  test 'sum of expenses for public agency' do
    total_expense = @controller.send(:expenses_public_agency, 1)
    expected_expense = 500
    assert_equal(expected_expense, total_expense)
  end

  test 'change type of array' do
    array = {3=>14, 5=>16, 7=>18}
    year = 2015
    controller_array = @controller.send(:change_type_list_expenses,array,year)
    correct_array = {2015=>{"Março"=>14, "Maio"=>16, "Julho"=>18}}

    assert_equal(correct_array, controller_array)
  end

  def create_fake_facebook
    url = 'http://graph.facebook.com/?ids=http://aondebrasil.com'\
    '/public_agency/1'
    shares = { 'http://aondebrasil.com/public_agency/1' => {
      'id' => 'http://aondebrasil.com/public_agency/1', 'shares' => 6 } }
    FakeWeb.register_uri(:get, url, body: shares.to_json)
  end

  def clean_database
    Expense.destroy_all
    PublicAgency.destroy_all
    SuperiorPublicAgency.destroy_all
  end

  def create_public_agency
    clean_database
    SuperiorPublicAgency.create(id: 1, name: 'SuperiorPublicAgency1')
    PublicAgency.create(name: 'PublicAgency1', id: 1,
                        superior_public_agency_id: 1, views_amount: 1)

    Expense.create(id: 1, document_number: '0000', value: 100,
                   public_agency_id: 1, payment_date: Date.new(2015, 6, 2))
    Expense.create(id: 2, document_number: '0000', value: 100,
                   public_agency_id: 1, payment_date: Date.new(2015, 2, 2))
    Expense.create(id: 3, document_number: '0000', value: 100,
                   public_agency_id: 1, payment_date: Date.new(2015, 3, 2))
    Expense.create(id: 4, document_number: '0000', value: 100,
                   public_agency_id: 1, payment_date: Date.new(2015, 5, 2))
    Expense.create(id: 5, document_number: '0000', value: 100,
                   public_agency_id: 1, payment_date: Date.new(2015, 4, 2))
  end
end
