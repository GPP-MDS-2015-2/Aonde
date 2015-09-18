class CreatePublicAgencies < ActiveRecord::Migration
  def change
    create_table :public_agencies do |t|
    t.timestamps null: false
    end
  end
end
