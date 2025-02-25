require 'pry'
class UsersController < ApplicationController

  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect to '/tweets'
    else
      erb :'users/login'
    end
  end
  
  get '/signup' do
    erb :'users/create_user'
  end

  post '/signup' do
    @user = User.new(username: params[:username], email: params[:email], password: params[:password])
    if @user.save 
      @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
     # flash[:message] = "You need an username, an email, and a password to signup."
      redirect to '/signup'
      #erb :'users/create_user'   (using this line causes errors even though the 'signup' route simply displays the create_user form)
    end
  end

  post '/login' do
    # binding.pry
    @user= User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
      flash[:message] = "Invalid username or password"
      #redirect to '/login'
      erb :'users/login'
    end
  end

  #Profile Page
  get "/users/:slug" do
    @user= User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/logout' do
    if Helpers.is_logged_in?(session)
      session.clear
      flash[:message] ="You have been successfully logged out."
      redirect to '/login'
    else
      redirect to '/'
    end
  end


end
