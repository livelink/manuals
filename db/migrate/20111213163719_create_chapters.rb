class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.references :manual
      t.string :title
      t.integer :chapter_no
      t.text :content

      t.timestamps
    end
    add_index :chapters, :manual_id
  end
end
