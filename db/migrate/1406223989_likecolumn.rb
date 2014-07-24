class Likecolumn < ActiveRecord::Migration
  def up
    add_column :messages, :like_count, :integer, default: 0
  end

  def down
    remove_column :messages, :like_count
  end
end
