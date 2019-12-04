class CharacterController < ApplicationController
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
      @user = current_user
      if @character&.user == @user
        erb :'characters/show'
      else
        redirect '/dashboard'
      end
    else
      redirect '/login'
    end
  end

  get '/characters/:slug/edit' do

  end

  get '/characters/:slug/delete' do

  end

  get '/characters/:slug/adventure-logs' do

  end

  post '/characters' do

  end

  patch '/characters/:slug' do

  end

  delete '/characters/:slug' do

  end

end