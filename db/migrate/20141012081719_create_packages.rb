class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :ref_number
      t.text :description
      t.float :weight
      t.float :height
      t.float :depth
      t.float :width
      t.float :value
      t.float :shipping_cost
      t.integer :status
      t.references :agency, index: true
      t.datetime :date_added
      t.datetime :date_arrived
      t.datetime :date_delivered
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :packages, :ref_number, unique: true
  end
end
