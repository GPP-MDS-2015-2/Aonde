class AddReferencesOnExpenses < ActiveRecord::Migration
  def change
  	change_table :expenses do |t|
  		
  		t.references :type_expense, index: true, foreign_key: true
  		t.references :company, index: true, foreign_key: true
  		t.references :function, index: true, foreign_key: true

  	end
  end
end
