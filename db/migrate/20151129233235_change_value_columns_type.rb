class ChangeValueColumnsType < ActiveRecord::Migration
  def change
    change_column :expenses, :value, :decimal, :precision => 14, :scale => 2
    change_column :public_agency_graph, :value, :decimal, :precision => 14, :scale => 2
    change_column :function_graph, :value, :decimal, :precision => 14, :scale => 2
    change_column :public_agencies, :views_amount, :integer, default: 0
  end
end
