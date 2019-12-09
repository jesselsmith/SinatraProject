class AdventureLogsController < ApplicationController
  get '/adventure-logs/new' do
    if logged_in?
      @user = current_user
      erb :'adventure-logs/new'
    else
      redirect '/login'
    end
  end

  get '/adventure-logs/new/:slug' do
    if logged_in?
      @character = Character.find_by_slug(params[:slug])
      if @character&.user == current_user
        erb :'adventure-logs/new-from-character'
      else
        redirect '/dashboard'
      end
    else
      redirect 'login'
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
        @magic_items = @adventure_log.character.magic_items -
                       @adventure_log.magic_items_gained
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
          adventure_log = character.adventure_logs.create(log_hash)
          gain_magic_items(params[:magic_items_gained], adventure_log)
          lose_magic_items(params[:magic_items_lost], adventure_log)
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
        new_items_gained_array = params[:adventure_log][:magic_items_gained].split("\n").map(&:strip)
        old_items_gained_array = adventure_log.magic_items_gained.map(&:name)
        magic_items_to_destroy = old_items_gained_array -
                                 new_items_gained_array
        magic_items_to_create = new_items_gained_array - old_items_gained_array
        old_items_lost_array = adventure_log.magic_items_lost.map(&:id)
        magic_items_to_lose = params[:adventure_log][:magic_items_lost] -
                              old_items_lost_array
        magic_items_to_gain = old_items_lost_array - params[:adventure_log][:magic_items_lost]
        
        MagicItem.find(magic_items_to_gain).each do |item|
          item.adventure_log_lost_id = nil
          item.character = adventure_log.character
          item.save
        end

        MagicItem.find(magic_items_to_lose).each do |item|
          item.adventure_log_lost_id = adventure_log.id
          item.character = nil
          item.save
        end

        MagicItem.where(name: magic_items_to_destroy, character: adventure_log.character).each(&:destroy)

        new_items = magic_items_to_create.map do |item_name|
          item = MagicItem.new(name: item_name)
          item.adventure_log_gained_id = adventure_log.id
          item.character = adventure_log.character
          item.save
        end
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
      if adventure_log&.user == current_user
        character = adventure_log.character
        character.magic_items << adventure_log.magic_items_lost
        character.save
        adventure_log.destroy
        redirect "/characters/#{character.slug}/adventure-logs"
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  # takes a hash from a form and returns a hash useful for creating a log
  def log_hasher(hash)
    log_hash = hash.except(:character, :magic_items_gained, :magic_items_lost)
    log_hash[:gold_gained] = hash[:gold_gained].to_i
    log_hash[:gold_lost] = hash[:gold_lost].to_i
    log_hash[:downtime_gained] = hash[:downtime_gained].to_i
    log_hash[:downtime_lost] = hash[:downtime_lost].to_i
    log_hash[:level_up] = (hash[:level_up] == 'true')
    log_hash
  end

  def gain_magic_items(magic_item_string, adventure_log)
    magic_items_gained = MagicItem.new_from_string(magic_item_string)
    adventure_log.magic_items_gained = magic_items_gained
    adventure_log.character.magic_items << magic_items_gained
  end

  def lose_magic_items(item_id_array, adventure_log)
    unless item_id_array.nil? || item_id_array.empty?
      magic_items_lost = MagicItem.find(item_id_array)
      adventure_log.magic_items_lost = magic_items_lost
      magic_items_lost.each do |item|
        item.character = nil
        item.save
      end
    end
  end

  def names_from_item_ids(array)
    if array.nil?
      ''
    else
      MagicItem.find(array).map(&:name).join("\n")
    end
  end

  def stringify_magic_item_array(array)
    array.join("\n")
  end

  def item_string_to_array(string)
    string.split("\n")
  end

  def item_string_to_items(string, character_id)
    item_string_to_array(string).map do |name|
      MagicItem.find_by(name: name, character_id: character_id)
    end
  end

  def destroy_items_in_string(string, character_id)
    item_string_to_array(string).each do |name|
      MagicItem.find_by(name: name, character_id: character_id).destroy
    end
  end

  def valid_log_hash(hash)
    !hash[:adventure_name].empty? && !hash[:dm_name].empty?
  end

  # def change_magic_items_based_on_hash(adventure_log, hash, array_of_items)
  #   if adventure_log.magic_items_lost != hash[:magic_items_lost]
  #     log_items_lost = item_string_to_array(adventure_log.magic_items_lost)
  #     hash_items_lost = item_string_to_array(hash[:magic_items_lost])
  #     items_to_make = log_items_lost - hash_items_lost
  #     items_to_destroy = hash_items_lost - log_items_lost

      

  #   end

  #   if adventure_log.magic_items_gained != hash[:magic_items_gained]
  #   end
  # end
end
