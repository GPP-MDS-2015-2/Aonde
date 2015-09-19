class AddColumnsToExpense < ActiveRecord::Migration
  def change
  	change_table :expenses do |t|
     
      t.references :program, index: true, foreign_key: true
      t.string :document_number
      t.date :payment_date
      t.double :value
      
    end
  end
end