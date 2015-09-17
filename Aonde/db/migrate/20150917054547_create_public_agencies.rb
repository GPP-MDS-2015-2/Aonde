class CreatePublicAgencies < ActiveRecord::Migration
  def change
    create_table :public_agencies do |t|

    t.references :superior_public_agency, index: true, foreign_key: true
    t.string :name
    t.integer :views_amount

    t.timestamps null: false
    end
  end
end