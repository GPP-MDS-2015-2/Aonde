class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
     
      t.references :program, index: true, foreign_key: true
      t.string :document_number
      t.integer :payment_management
      t.date :payment_date
      
      t.timestamps null: false
    end
  end
end
