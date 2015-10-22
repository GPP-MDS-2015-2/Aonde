class CreateCompareBudgetsExpenses < ActiveRecord::Migration
  def change
    create_table :compare_budgets_expenses do |t|

      t.timestamps null: false
    end
  end
end
