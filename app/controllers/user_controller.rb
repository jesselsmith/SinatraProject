class UserController < ApplicationController
  get '/users/:slug' do
    if logged_in?
      @user =  User.find_by_slug(params[:slug])
      if @user&.id == session[:user_id]
        erb :'users/show'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/users/:slug/edit' do
    if logged_in?
      @user =  User.find_by_slug(params[:slug])
      if @user&.id == session[:user_id]
        erb :'users/show'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/users/:slug/delete' do

  end

  post '/users' do

  end

  patch '/users/:slug' do

  end

  delete '/users/:slug' do

  end
end
