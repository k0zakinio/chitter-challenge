require 'sinatra/base'
require 'sinatra/flash'
require './app/support/data_mapper_setup'

class Chitter < Sinatra::Base
  register Sinatra::Flash
  enable :sessions
  set :session_secret, 'super secret'

helpers do
  def current_user
    @current_user || User.get(session[:user_id])
  end
end

  get '/' do
    erb :index
  end

  get '/users/register' do
    erb(:'users/register')
  end

  post '/users/register' do
    user = User.create(
      email:    params[:email],
      name:     params[:name],
      username: params[:username],
      password: params[:password]
      )
    flash.now[:errors] = user.errors.full_messages unless \
    user.errors.full_messages.length == 0
    erb(:'/users/register')
  end

  get '/users/sign_in' do
    erb(:'users/sign_in')
  end

  post '/users/sign_in' do
    if user = User.validate(params[:email], params[:password])
      session[:user_id] = user.id
      redirect('/')
    end
  end

  run! if app_file == $0
end