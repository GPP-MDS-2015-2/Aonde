class CreateSuperiorPublicAgencies < ActiveRecord::Migration
  def change
    create_table :superior_public_agencies do |t|

    t.string name:

    t.timestamps null: false
    end
  end
end
