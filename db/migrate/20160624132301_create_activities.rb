class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true, foreign_key: true
      t.references :streamable, polymorphic: true, index: true
      t.string :action, null: false
      t.string :title, null: true
      t.timestamps null: false
      t.datetime :deleted_at, null: true
    end
  end
end
