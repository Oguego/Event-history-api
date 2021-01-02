class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.datetime :when
      t.string :user
      t.string :event_type
      t.string :data_before
      t.string :data_after
      t.belongs_to :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
