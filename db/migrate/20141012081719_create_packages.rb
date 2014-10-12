class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :ref_number, null: false
      t.text :description, null: false
      t.float :weight, null: false
      t.float :height, null: false
      t.float :depth, null: false
      t.float :width, null: false
      t.float :value, null: false
      t.float :shipping_cost, null: false
      t.integer :status, default: 0
      t.references :agency, index: true
      t.datetime :date_added
      t.datetime :date_arrived
      t.datetime :date_delivered
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false

      t.timestamps
    end
    add_index :packages, :ref_number, unique: true
  end
end
