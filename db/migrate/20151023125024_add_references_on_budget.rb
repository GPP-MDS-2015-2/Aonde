class AddReferencesOnBudget < ActiveRecord::Migration
  def change
  	change_table :budgets do |t|
  		
  		t.references :public_agency, index: true, foreign_key: true

  	end
  end
end