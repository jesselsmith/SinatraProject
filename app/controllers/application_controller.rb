# frozen_string_literal: true

require './config/environment'
require 'sysrandom/securerandom'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect "/dashboard"
    else
      erb :signup
    end
  end

  post '/signup' do
    user = User.new(params)
    if valid_signup?(user) && user.save
      session[:user_id] = user.id
      redirect "/dashboard"
    else
      redirect "/signup"
    end
  end

  get '/login' do
    if logged_in?
      redirect '/dashboard'
    else
      erb :login
    end
  end

  post '/login' do
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/dashboard"
    else
      redirect "/login"
    end
  end

  get '/dashboard' do
    if logged_in?
      @user = current_user
      erb :dashboard
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear if logged_in?
    redirect '/login'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(id: session[:user_id])
    end

    def valid_signup?(user)
      !user.name.empty? && !user.email.empty? && !user.password_digest.empty?
    end
  end
end
