class AddColumnsToExpenses < ActiveRecord::Migration
  def change
  	change_table :expenses do |t|
    
      t.decimal :value
      
    end
  end
end