class CharactersController < ApplicationController
  get '/characters' do
    if logged_in?
      @user = current_user
      @characters = @user.characters
      erb :'characters/index'
    else
      redirect '/login'
    end
  end

  get '/characters/new' do
    if logged_in?
      @user = current_user
      erb :'characters/new'
    else
      redirect '/login'
    end
  end

  get '/characters/:slug' do
    if logged_in?
      @character = Character.find_by_slug(params[:slug])
      if @character&.user == current_user
        erb :'characters/show'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/characters/:slug/edit' do
    if logged_in?
      @character = Character.find_by_slug(params[:slug])
      if @character&.user == current_user
        erb :'characters/edit'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/characters/:slug/delete' do
    if logged_in?
      @character = Character.find_by_slug(params[:slug])
      if @character&.user == current_user
        erb :'characters/delete'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/characters/:slug/adventure-logs' do
    if logged_in?
      @character = Character.find_by_slug(params[:slug])
      if @character&.user == current_user
        erb :'characters/adventure-logs'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  post '/characters' do
    if logged_in?
      user = current_user
      character_hash = character_hasher(params)
      if valid_character_hash(character_hash)
        character = user.characters.build(character_hash)
        character.save
        redirect "/characters/#{character.slug}"
      else
        redirect '/characters/new'
      end
    else
      redirect '/login'
    end
  end

  patch '/characters/:slug' do
    if logged_in?
      character = find_by_slug(params[:slug])
      if character&.user == current_user
        if valid_character_hash(params[:character])
          character.update(params[:character])
          redirect "/characters/#{character.slug}"
        else
          redirect "/characters/#{character.slug}/edit"
        end
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  delete '/characters/:slug' do
    if logged_in?
      character = find_by_slug(params[:slug])
      character.destroy if character&.user == current_user
      redirect "/characters/#{character.slug}"
    else
      redirect '/login'
    end
  end


  def character_hasher(hash)
    character_hash = hash
    character_hash[:level] = hash[:level].to_i
    character_hash[:gold] = hash[:gold].to_i
    character_hash[:downtime] = hash[:downtime].to_i
    character_hash[:adventurers_league] = (hash[:adventurers_league] == 'true')
    character_hash
  end

  def valid_character_hash(hash)
    !hash[:name].empty? && hash[:level].positive? && hash[:level] <= 20
  end
end