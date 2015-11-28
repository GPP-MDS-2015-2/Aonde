require 'test_helper'

class TypeExpenseControllerTest < ActionController::TestCase
  
  # assert_routing({ path: 'public_agency/:id/expenese_type', method: :get },{ controller: 'type_expense', action: 'get_expense_by_type' })

  test 'Route to method show and the result of the request on type expense controller' do
    create_entities
    assert_routing '/public_agency/1/type_expense',
                   controller: 'type_expense', action: 'show', id: '1'
    get :show, id: 1, format: :json
    assert_response :success
  end

  test 'Routes to method filter_chart' do
    create_entities
    assert_routing '/public_agency/1/filter_type_expense',
                   controller: 'type_expense', action: 'filter_chart', id: '1'
  end
  
  test 'Sum of the type expenses in method get_expense_by_type' do
    create_entities
    id_public_agency = 1
    expense_type_list = @controller.get_expense_by_type(id_public_agency, '2013')

    expected_list = [{ name: 'Type expense one valid', value: 500, colorValue: 50 },
                     { name: 'Type expense three valid', value: 500,
                       colorValue: 50 }]

    assert_equal(expected_list, expense_type_list)
  end

  test 'The calculo of the color based in the porcent in method define_color' do
    total_expense = 100

    expense_list = [{ value: 20, colorValue: 0 }, { value: 40, colorValue: 0 },
                    { value: 18, colorValue: 0 }, { value: 10, colorValue: 0 },
                    { value: 5, colorValue: 0 }, { value: 2.5, colorValue: 0 },
                    { value: 2.5, colorValue: 0 }, { value: 1.999, colorValue: 0 },
                    { value: 0.001, colorValue: 0 }]
    @controller.define_color(total_expense, expense_list)

    expected_list = [{ value: 20, colorValue: 20 }, { value: 40, colorValue: 40 },
                     { value: 18, colorValue: 18 }, { value: 10, colorValue: 10 },
                     { value: 5, colorValue: 5 }, { value: 2.5, colorValue: 2 },
                     { value: 2.5, colorValue: 2 }, { value: 1.999, colorValue: 1 },
                     { value: 0.001, colorValue: 0 }]
    assert_equal(expected_list, expense_list, 'The two list are different')

    expense_list = [{ value: 20, colorValue: 0 }, { value: 40, colorValue: 0 },
                    { value: 18, colorValue: 0 }, { value: 10, colorValue: 0 },
                    { value: 5, colorValue: 0 }, { value: 2.5, colorValue: 0 },
                    { value: 2.5, colorValue: 0 }, { value: 1.999999999999999999999999, colorValue: 0 },
                    { value: 0.001, colorValue: 0 }]

    @controller.define_color(total_expense, expense_list)

    not_expected_list = [{ value: 20, colorValue: 20 }, { value: 40, colorValue: 40 },
                         { value: 18, colorValue: 18 }, { value: 10, colorValue: 10 },
                         { value: 5, colorValue: 5 }, { value: 2.5, colorValue: 2 },
                         { value: 2.5, colorValue: 2 }, { value: 1.999999999999999999999999, colorValue: 1 },
                         { value: 0.001, colorValue: 0 }]
    assert_not_equal(not_expected_list, expense_list, 'The list is equals at the not expected')
  end

  def create_entities
    SuperiorPublicAgency.create(id: 1, name: 'valid SuperiorPublicAgency')

    PublicAgency.create(id: 1, views_amount: 0, name: 'valid Agency', superior_public_agency_id: 1)
    PublicAgency.create(id: 2, views_amount: 0, name: 'valid Agency', superior_public_agency_id: 1)

    TypeExpense.create(id: 1, description: 'Type expense one valid')
    TypeExpense.create(id: 2, description: 'Type expense two invalid')
    TypeExpense.create(id: 3, description: 'Type expense three valid')

    Expense.create(document_number: '0000', payment_date: Date.new(2010, 1, 1),
                   public_agency_id: 2, type_expense_id: 2, value: 100)
    for i in 1..5
      Expense.create(document_number: '0000', payment_date: Date.new(2013, i, 1),
                     public_agency_id: 1, type_expense_id: 1, value: 100)
     end
    for i in 1..5
      Expense.create(document_number: '0000', payment_date: Date.new(2013, i, 1),
                     public_agency_id: 1, type_expense_id: 3, value: 100)
     end
 end
end
