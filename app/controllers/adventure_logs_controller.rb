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
      @adventure_log = AdventureLog.find_by(id: params[:id])
      if @adventure_log&.user == current_user
        erb :'adventure-logs/edit'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/adventure-logs/:id/delete' do
    if logged_in?
      @adventure_log = AdventureLog.find_by(id: params[:id])
      if @adventure_log&.user == current_user
        erb :'adventure-logs/delete'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/adventure-logs/:id' do
    if logged_in?
      @adventure_log = AdventureLog.find_by(id: params[:id])
      if @adventure_log&.user == current_user
        erb :'adventure-logs/show'
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
          adventure_log = character.adventure_logs.build(log_hash)
          MagicItem.new_from_adventure_log(adventure_log)
          character.save
          redirect "/adventure-logs/#{adventure_log.id}"
        else
          redirect '/adventure-logs/new'
        end
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  patch '/adventure-logs/:id' do
    if logged_in?
      adventure_log = AdventureLog.find_by(id: params[:id])
      if adventure_log&.user == current_user
        log_hash = log_hasher(params[:adventure_log])
        if valid_log_hash(log_hash)
          adventure_log.update(log_hash)
          redirect "/adventure-logs/#{adventure_log.id}"
        else
          redirect "/adventure-logs/#{adventure_log.id}/edit"
        end
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  delete '/adventure-logs/:id' do
    if logged_in?
      adventure_log = AdventureLog.find_by(id: params[:id])
      adventure_log.destroy if adventure_log&.user == current_user
      redirect "/adventure-logs"
    else
      redirect '/login'
    end
  end

  # takes a hash from a form and returns a hash useful for creating a log
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