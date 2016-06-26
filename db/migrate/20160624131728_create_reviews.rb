class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :place, null: true
      t.string :hours, null: true
      t.integer :rating, null: false, default: 0
      t.string :tags
      t.timestamps null: false
      t.datetime :deleted_at, null: true
    end
  end
end
