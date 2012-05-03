# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111216172129) do

  create_table "chapters", :force => true do |t|
    t.integer  "manual_id"
    t.string   "title"
    t.integer  "chapter_no"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chapters", ["manual_id"], :name => "index_chapters_on_manual_id"

  create_table "illustrations", :force => true do |t|
    t.string   "name"
    t.string   "alt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  create_table "manuals", :force => true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "summary"
    t.text     "audience"
    t.string   "visibility"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
