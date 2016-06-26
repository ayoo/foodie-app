class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.string :tags, null: true
      t.timestamps null: false
      t.datetime :deleted_at, null: true
    end
  end
end