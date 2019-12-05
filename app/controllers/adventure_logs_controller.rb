class AdventureLogsController < ApplicationController
  get '/adventure-logs/new' do
    if logged_in?
      @user = current_user
      erb :'adventure-logs/new'
    else
      redirect '/login'
    end
  end

  get '/adventure-logs' do
    if logged_in?
      @user = current_user
      @adventure_logs = @user.adventure_logs
      erb :'adventure-logs/index'
    else
      redirect '/login'
    end
  end

  get '/adventure-logs/:id/edit' do
    if logged_in?
      @adventure_log = Adventure_logs.find_by(id: params[:id])
      if @adventure_log&.user == current_user
        erb :'adventure_logs/edit'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/adventure-logs/:id/delete' do
    if logged_in?
      @adventure_log = Adventure_logs.find_by(id: params[:id])
      if @adventure_log&.user == current_user
        erb :'adventure_logs/delete'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/adventure-logs/:id' do
    if logged_in?
      @adventure_log = Adventure_logs.find_by(id: params[:id])
      if @adventure_log&.user == current_user
        erb :'adventure_logs/show'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end


  post '/adventure-logs' do

  end

  patch '/adventure-logs/:id' do
  
  end

  delete '/adventure-logs/:id' do
  
  end
end