class RemoveColumnsToExpenses < ActiveRecord::Migration
  def change
  	change_table :expenses do |t|
    
      t.remove :payment_management
      
    end
  end
end