class RemoveExpensesPrimaryKey < ActiveRecord::Migration
  def change
    remove_column :expenses, :id
    add_index :expenses, [:value, :payment_date, :document_number], :unique => true
  end
end
