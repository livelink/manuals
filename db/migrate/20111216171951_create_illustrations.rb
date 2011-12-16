class CreateIllustrations < ActiveRecord::Migration
  def change
    create_table :illustrations do |t|
      t.string :name
      t.string :alt

      t.timestamps
    end
  end
end
