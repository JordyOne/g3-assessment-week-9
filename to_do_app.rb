require "sinatra"
require "gschool_database_connection"
require "rack-flash"
require "active_record"
require "./lib/to_do_item"
require "./lib/user"

class ToDoApp < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if current_user
      user = current_user
      users = User.where("id != #{user.id}")
      todos = ToDoItem.where("id = #{user.id}")

      erb :signed_in, locals: {current_user: user, users: users, todos: todos}
    else
      erb :signed_out
    end
  end

  get "/register" do
    erb :register, locals: {user: User.new}
  end

  post "/registrations" do
    user = User.new(username: params[:username], password: params[:password])

    if user.save
      flash[:notice] = "Thanks for registering"
      redirect "/"
    else
      erb :register, locals: {user: user}
    end
  end

  post "/sessions" do

    user = authenticate_user

    if user != nil
      session[:user_id] = user.id
    else
      flash[:notice] = "Username/password is invalid"
    end

    redirect "/"
  end

  delete "/sessions" do
    session[:user_id] = nil
    redirect "/"
  end

  post "/todos" do
    ToDoItem.create(body: params[:body])

    flash[:notice] = "ToDo added"

    redirect "/"
  end

  post "/edit/:id" do
    current_todo = ToDoItem.find_by(id: params[:id])
    erb :edit_page, locals: {current_todo: current_todo}
  end

  patch "/todos/:id" do
    ToDoItem.update(params[:id], body: params[:body])
    flash[:notice] = "ToDo Updated"
    redirect "/"
  end

  post "/complete/:id" do
    p ToDoItem.find_by(id: params[:id]).destroy
    flash[:notice] = "ToDo completed"
    redirect "/"
  end


  private

  def authenticate_user
    User.authenticate(params[:username], params[:password])
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end
