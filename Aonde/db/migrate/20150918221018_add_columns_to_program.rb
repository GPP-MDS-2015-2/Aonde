class AddColumnsToProgram < ActiveRecord::Migration
  def change
  	change_table :programs do |t|

  	  t.references :public_agency, index: true, foreign_key: true
      t.string :name
    end
  end
end
