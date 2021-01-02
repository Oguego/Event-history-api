class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :object_type
      t.integer :object_id

      t.timestamps
    end
  end
end
