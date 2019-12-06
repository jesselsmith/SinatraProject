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
    if logged_in?
      character = Character.find(params[:character])
      if character&.user == current_user
        log_hash = log_hasher(params)
        if valid_log_hash(log_hash)

          adventure_log = user.adventure_logs.build(log_hash)
          adventure_log.save
          redirect "/adventure_logs/#{adventure_log.slug}"
        else
          redirect '/adventure_logs/new'
        end
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  patch '/adventure-logs/:id' do
  
  end

  delete '/adventure-logs/:id' do
  
  end

  # takes a hash from a form and returns a hash useful for creating a character
  def log_hasher(hash)
    log_hash = hash.except(:character)
    log_hash[:gold_change] = hash[:gold_change].to_i
    log_hash[:downtime_change] = hash[:downtime_change].to_i
    log_hash[:level_up] = (hash[:level_up] == 'true')
    log_hash
  end

  def valid_log_hash(hash)
    !hash[:adventure_name].empty? && !hash[:dm_name].empty?
  end
end