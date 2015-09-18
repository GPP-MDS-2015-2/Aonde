class AddFieldsToProgram < ActiveRecord::Migration
  def change
  	create_table :programs do |t|

  	t.references :public_agency, index: true, foreign_key: true
    t.string :name
  end
end
