class CreateFunctionGraph < ActiveRecord::Migration
  def change
    create_table :function_graph,:id => false do |t|
    	t.string :description
    	t.integer :year
    	t.integer :function_id
    	t.decimal :value
    end
    add_index :function_graph,[:function_id,:year],:unique => true 
  end
end
