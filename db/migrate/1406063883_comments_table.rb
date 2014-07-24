class CommentsTable < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string  :comments
      t.integer :message_id
  end

  def down
    drop_table :comments
  end
end
end