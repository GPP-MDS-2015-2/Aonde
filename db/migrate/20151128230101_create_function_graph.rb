class CreateFunctionGraph < ActiveRecord::Migration
  def change
    create_table :function_graphs,:id => false do |t|
    	t.string :description
    	t.integer :year
    	t.integer :function_id
    	t.decimal :value
    end
    add_index :function_graphs,[:function_id,:year],:unique => true 
  end
end
