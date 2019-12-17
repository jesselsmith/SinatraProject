class UsersController < ApplicationController
  get '/users/:id' do
    if logged_in?
      @user = User.find_by_id(params[:id])
      if @user == current_user
        erb :'users/show'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/users/:id/edit' do
    if logged_in?
      @user = User.find_by_id(params[:id])
      if @user == current_user
        erb :'users/edit'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/users/:id/delete' do
    if logged_in?
      @user = User.find_by_id(params[:id])
      if @user == current_user
        erb :'users/delete'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  patch '/users/:id' do
    if logged_in?
      user = User.find_by_id(params[:id])
      if user == current_user
        if params[:user][:password].empty?
          if user.update(params[:user].except(:password))
            redirect '/dashboard'
          else
            redirect "/users/#{params[:id]}/edit"
          end
        else
          if user.update(params[:user])
            redirect '/dashboard'
          else
            redirect "/users/#{params[:id]}/edit"
          end
        end
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  delete '/users/:id' do
    if logged_in?
      user = User.find_by_id(params[:id])
      if user == current_user
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
