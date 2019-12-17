class AdventureLogsController < ApplicationController
  get '/adventure-logs/new' do
    if logged_in?
      @user = current_user
      erb :'adventure-logs/new'
    else
      redirect '/login'
    end
  end

  get '/adventure-logs/new/:id' do
    if logged_in?
      @character = current_user.characters.find_by_id(params[:id])
      if !!@character
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
      @adventure_log = current_user.adventure_logs.find_by(id: params[:id])
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
      @adventure_log = current_user.adventure_logs.find_by(id: params[:id])
      if !!@adventure_log
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
      character = current_user.characters.find(params[:character])
      if !!character
        adventure_log = character.adventure_logs.build(
          params.except(:character, :magic_items_gained, :magic_items_lost)
        )
        if adventure_log.save
          gain_magic_items(params[:magic_items_gained], adventure_log)
          lose_magic_items(params[:magic_items_lost], adventure_log)
          adventure_log.save
          character.save
          redirect "/adventure-logs/#{adventure_log.id}"
        else
          redirect "/adventure-logs/new/#{character.id}"
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
      adventure_log = current_user.adventure_logs.find_by(id: params[:id])
      if !!adventure_log
        if adventure_log.update(params[:adventure_log]
          .except(:character, :magic_items_gained, :magic_items_lost))
          edit_magic_items(params[:adventure_log], adventure_log)
          adventure_log.save
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
      adventure_log = current_user.adventure_logs.find_by(id: params[:id])
      if !!adventure_log
        character = adventure_log.character
        character.magic_items << adventure_log.magic_items_lost
        character.save
        adventure_log.destroy
        redirect "/characters/#{character.id}/adventure-logs"
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  private

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

  def edit_magic_items(hash, adventure_log)
    editing_arrays = editing_arrays(hash, adventure_log)
    binding.pry
    create_magic_items_from_edit_view(editing_arrays[:magic_items_to_create],
                                      adventure_log)
    destroy_magic_items_from_edit_view(editing_arrays[:magic_items_to_destroy],
                                       adventure_log.character)
    lose_magic_items_from_edit_view(editing_arrays[:magic_items_to_lose],
                                    adventure_log)
    gain_magic_items_from_edit_view(editing_arrays[:magic_items_to_gain],
                                    adventure_log)
    adventure_log.character.save
  end

  def editing_arrays(hash, adventure_log)
    item_arrays = magic_item_editing_array_maker(hash, adventure_log)
    {
      magic_items_to_create: item_arrays[:new_items_gained] -
        item_arrays[:old_items_gained],
      magic_items_to_destroy: item_arrays[:old_items_gained] -
        item_arrays[:new_items_gained],
      magic_items_to_lose: (hash[:magic_items_lost] ? hash[:magic_items_lost].map(&:to_i) : [])-
        item_arrays[:old_items_lost],
      magic_items_to_gain: item_arrays[:old_items_lost] -
        (hash[:magic_items_lost] ? hash[:magic_items_lost].map(&:to_i) : [])
    }
  end

 
  def magic_item_editing_array_maker(hash, adventure_log)
    {
      new_items_gained: hash[:magic_items_gained].split("\n").map(&:strip),
      old_items_gained: adventure_log.magic_items_gained.map(&:name),
      old_items_lost: adventure_log.magic_items_lost.map(&:id)
    }
  end

  def create_magic_items_from_edit_view(name_array, adventure_log)
    name_array.map do |item_name|
      item = MagicItem.new(name: item_name)
      item.adventure_log_gained_id = adventure_log.id
      item.character = adventure_log.character
      item.save
    end
  end

  def destroy_magic_items_from_edit_view(name_array, character)
    MagicItem.where(name: name_array, character: character).each(&:destroy)
  end

  def lose_magic_items_from_edit_view(item_id_array, adventure_log)
    MagicItem.find(item_id_array).each do |item|
      item.adventure_log_lost_id = adventure_log.id
      item.character = nil
      item.save
    end
  end

  def gain_magic_items_from_edit_view(item_id_array, adventure_log)
    MagicItem.find(item_id_array).each do |item|
      item.adventure_log_lost_id = nil
      item.character = adventure_log.character
      item.save
    end
  end
end
