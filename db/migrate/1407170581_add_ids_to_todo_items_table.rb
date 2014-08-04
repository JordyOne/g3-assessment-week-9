class AddIdsToTodoItemsTable < ActiveRecord::Migration
  def change
    add_column :to_do_items, :user_id, :string # I couldn't find if an id is a string or int, so I went with string
  end
end
