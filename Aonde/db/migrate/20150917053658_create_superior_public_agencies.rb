class CreateSuperiorPublicAgencies < ActiveRecord::Migration
  def change
    create_table :superior_public_agencies do |t|

      t.timestamps null: false
 	end
  end
end