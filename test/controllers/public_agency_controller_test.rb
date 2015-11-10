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

    assert assigns(:list_expense_month)
    assert assigns (:total_expense)
  end

  test 'get to filter chart' do
    create_public_agency
    get :filter_chart, id: 1, from_year: 2010, end_year: 2015,
                       from_month: 'Janeiro', end_month: 'Junho'
    assert_response :success
    assert assigns(:list_expense_month)
  end
  test 'get filter chart with invalid date' do
    create_public_agency
    get :filter_chart, id: 1, from_year: 2016, end_year: 2015,
                       from_month: 'Janeiro', end_month: 'Junho'
    assert_response :success
    assert assigns(:list_expense_month)
    assert_equal("Não encontrou nenhum gasto no periodo\n Veja o gráfico"\
      ' com todos gastos', flash[:error])
  end

  test 'increment one unit in views amount' do
    public_agency = PublicAgency.find(1)
    @controller.send(:increment_views_amount, public_agency)
    assert_equal(2, public_agency.views_amount)
  end
  test 'valid date to generate a list with expenses of public agency' do
    date = { from_month: 'Janeiro', end_month: 'Dezembro', from_year: 2014,
             end_year: 2015 }
    public_agency = PublicAgency.find(1)
    list = @controller.send(:create_list_expense, date, public_agency)
    assert_not_empty(list[:total_date])
  end
  test 'Raise exception to invalid data' do
    date = { from_month: 'Janeiro', end_month: 'Dezembro', from_year: 2015,
             end_year: 2010 }
    public_agency = PublicAgency.find(1)
    assert_raise(Exception) do
      list = @controller.send(:create_list_expense, date, public_agency)
    end
  end

  test 'sum of expenses for public agency' do
    total_expense = @controller.send(:expenses_public_agency, 1)
    expected_expense = 500
    assert_equal(expected_expense, total_expense)
  end

  test 'size of generate expenses by date for public agency' do
    begin_date = Date.new(2015, 1, 2)
    end_date = Date.new(2015, 4, 2)
    expenses_public_agency = @controller.send(:get_expenses_agency, 1,
                                              begin_date, end_date)
    assert_equal(3, expenses_public_agency[:total_date].size)
  end

  test 'empty list to public agency without expenses in date interval' do
    begin_date = Date.new(2014, 1, 2)
    end_date = Date.new(2014, 6, 2)
    expenses_public_agency = @controller.send(:get_expenses_agency, 1,
                                              begin_date, end_date)
    assert_empty(expenses_public_agency[:total_date])
    assert_equal(0, expenses_public_agency[:total])
  end

  test 'sorted result of list' do
    begin_date = Date.new(2015, 1, 2)
    end_date = Date.new(2015, 4, 2)
    expenses_public_agency = @controller.send(:get_expenses_agency, 1,
                                              begin_date, end_date)
    expected_expenses = { total: 300,
                          total_date: [
                            ['02/2015', 100], ['03/2015', 100],
                            ['04/2015', 100]] }
    assert_equal(expected_expenses, expenses_public_agency)
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
