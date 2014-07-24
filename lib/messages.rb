class Messages
  def initialize(db_connection)
    @database_connection = db_connection
  end

  def show_all
    @database_connection.sql("SELECT * FROM messages")
  end

  def create_message(message)
    @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
  end

  def update_message(message, id)
    @database_connection.sql("UPDATE messages SET message='#{message}' WHERE id=#{id}")
  end

  def find_by_id(id)
    @database_connection.sql("SELECT * from messages WHERE id=#{id}").first
  end

  def delete_by_id(id)
    @database_connection.sql("DELETE FROM messages WHERE id=#{id}").first
    @database_connection.sql("DELETE FROM comments WHERE message_id=#{id}").first
  end

  def increment_like_count(amount, current_like_count, id)
    new_like_count = amount + current_like_count
    @database_connection.sql("UPDATE messages SET like_count=#{new_like_count} WHERE id=#{id}")
  end

end