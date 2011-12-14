class CreateManuals < ActiveRecord::Migration
  def change
    create_table :manuals do |t|
      t.string :slug
      t.string :title
      t.text :summary
      t.text :audience
      t.string :visibility

      t.timestamps
    end
  end
end
