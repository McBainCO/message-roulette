class CommentsTable < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string  :comments
  end

  def down
    drop_table :comments
  end
end
end