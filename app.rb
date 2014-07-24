require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"
require "./lib/messages"
require "./lib/comments"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @messages = Messages.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))
    @comments = Comments.new(GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"]))

    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @messages.show_all
    comments = @comments.show_all
    erb :home, locals: {messages: messages, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @messages.create_message(message)
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id/edit" do
    id = params[:id].to_i
    message_to_edit = @messages.find_by_id(id)
    erb :edit, locals: {message_to_edit: message_to_edit}
  end

  patch "/messages/:id" do
    if params[:update]
      message_to_edit = params[:message]
      if message_to_edit.length <= 140
        @messages.update_message(message_to_edit, params[:id].to_i)
        redirect "/"
      else
        flash[:error] = "Message must be less than 140 characters."
        erb :edit, locals: {message_to_edit: message_to_edit}
      end
    elsif params[:like_ness]
      count_direction = params[:like_ness].to_i
      @messages.increment_like_count(count_direction, params[:like_count].to_i, params[:id].to_i)
      redirect "/"
    else-
    "BOOM"
    end
  end

  delete "/messages/:id" do
    id = params[:id].to_i
    @messages.delete_by_id(id)
    redirect "/"
  end

  #SHOW
  get "/messages/:id" do
    id = params[:id].to_i
    message = @messages.find_by_id(id)
    comments = @comments.find_by_message_id(id)
    erb :show, locals: {message: message, comments: comments}
  end

  #NEW COMMENT
  get "/comments/new/:id" do
    message_id = params[:id].to_i
    erb :new_comment, locals: {message_id: message_id}
  end

  post "/comments" do
    begin
      @comments.create_comment(params[:message_id].to_i, params[:comment])
      redirect "/"
    rescue
      erb :new_comment, locals: {message_id: params[:message_id]}
    end
  end


end