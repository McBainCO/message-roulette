class Comments
  def initialize(db_connection)
    @database_connection = db_connection
  end

  def show_all
    @database_connection.sql("SELECT * FROM comments")
  end

  def find_by_message_id(id)
    @database_connection.sql("SELECT * FROM comments WHERE message_id=#{id}")
  end

  def create_comment(message_id, comment)
    @database_connection.sql("INSERT INTO comments (message_id, comment) VALUES (#{message_id}, '#{comment}')")
  end

end