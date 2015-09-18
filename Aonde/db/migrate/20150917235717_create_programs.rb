class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.references :public_agency, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
