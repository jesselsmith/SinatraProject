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

  get '/characters/:id/edit' do
    if logged_in?
      @character = current_user.characters.find_by_id(params[:id])
      if !!@character
        erb :'characters/edit'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/characters/:id/delete' do
    if logged_in?
      @character = current_user.characters.find_by_id(params[:id])
      if !!@character
        erb :'characters/delete'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/characters/:id/adventure-logs' do
    if logged_in?
      @character = current_user.characters.find_by_id(params[:id])
      if !!@character
        erb :'characters/adventure-logs'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/characters/:id' do
    if logged_in?
      @character = current_user.characters.find_by_id(params[:id])
      if !!@character
        erb :'characters/show'
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
      character = user.characters.build(params)
      if character.save
        redirect "/characters/#{character.id}"
      else
        redirect '/characters/new'
      end
    else
      redirect '/login'
    end
  end

  patch '/characters/:id' do
    if logged_in?
      character = current_user.characters.find_by_id(params[:id])
      if !!character
        if character.update(params[:character])
          redirect "/characters/#{character.id}"
        else
          redirect "/characters/#{character.id}/edit"
        end
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  delete '/characters/:id' do
    if logged_in?
      @character = current_user.characters.find_by_id(params[:id])
      if !!@character
        character.destroy
        redirect "/characters"
      else
        redirect "/dashboard"
      end
    else
      redirect '/login'
    end
  end
end
