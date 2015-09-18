class AddFieldsToExpense < ActiveRecord::Migration
  def change
  	change_table :expenses do |t|
     
      t.references :program, index: true, foreign_key: true
      t.string :document_number
      t.integer :payment_management
      t.date :payment_date
    end
  end
end