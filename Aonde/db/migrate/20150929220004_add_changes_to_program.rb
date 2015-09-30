class AddChangesToProgram < ActiveRecord::Migration
  def change
  	change_table :programs do |t|
    
      remove_foreign_key :programs, :public_agencies
      remove_index :programs, :public_agency_id
      t.remove :public_agency_id
      t.string :description

      
      
    end
  end
end