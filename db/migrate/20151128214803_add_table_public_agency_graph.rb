class AddTablePublicAgencyGraph < ActiveRecord::Migration
  def change
    create_table :public_agency_graph, id: false do |t|
      t.decimal :value
      t.integer :year
      t.integer :id_public_agency
    end
    add_index :public_agency_graph, [:year, :id_public_agency], :unique => true
  end
end
