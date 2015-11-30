require 'test_helper'
=begin
class ExpenseTest < ActiveSupport::TestCase

  def document_number_nil
    expense = Expense.new(:document_number => expenses(:document_number_nil).document_number, :payment_date => expenses(:document_number_nil).payment_date)
 
    assert_not expense.valid?
    assert_not expense.save
  end

  def not_a_number
    expense = Expense.new(:document_number => expenses(:not_a_number).document_number, :payment_date => expenses(:not_a_number).payment_date)

    assert_not expense.valid?
    assert_not expense.save
  end

  def not_a_data
    expense = Expense.new(:document_number => expenses(:not_a_data).document_number, :payment_date => expenses(:not_a_data).payment_date)

    assert_not expense.valid?
    assert_not expense.save
  end


  def right_case
    expense = Expense.new(:document_number => expenses(:right_case).document_number, :payment_date => expenses(:right_case).payment_date)

    assert expense.valid?
    assert expense.save
  end

end
=end
