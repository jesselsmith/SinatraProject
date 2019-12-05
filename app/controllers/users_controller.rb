class UsersController < ApplicationController
  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
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
      @user = User.find_by_slug(params[:slug])
      if @user&.id == session[:user_id]
        erb :'users/edit'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/users/:slug/delete' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      if @user&.id == session[:user_id]
        erb :'users/delete'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  patch '/users/:slug' do
    if logged_in?
      user = User.find_by_slug(params[:slug])
      if user&.id == session[:user_id]
        if !params[:user][:name].empty? && !params[:user][:email].empty?
          if params[:user][:password].empty?
            user.update(params[:user].except(:password))
          else
            user.update(params[:user])
          end
          redirect '/dashboard'
        else
          redirect "/users/#{params[:slug]}/edit"
        end
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  delete '/users/:slug' do
    if logged_in?
      user = User.find_by_slug(params[:slug])
      if user&.id == session[:user_id]
        user.destroy
        redirect '/logout'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end
end
