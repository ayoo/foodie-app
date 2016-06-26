class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title, null: false
      t.text   :content, null: false
      t.string :style, null: true
      t.integer :serves_for, null: true # for 2 or 3 people
      t.string :ingredients, null: true
      t.integer :cook_time, null: true
      t.integer :ready_time, null: true
      t.timestamps null: false
      t.datetime :deleted_at, null: true
    end
  end
end
