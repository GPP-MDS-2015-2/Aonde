class CreateTypeExpenses < ActiveRecord::Migration
  def change
    create_table :type_expenses do |t|

    	t.string :description
      	t.timestamps null: false
    
    end
  end
end
