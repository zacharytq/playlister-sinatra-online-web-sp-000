require 'rack-flash'

class SongsController < ApplicationController
    enable :sessions
    use Rack::Flash

    get '/songs' do
        @songs = Song.all
        erb :"/songs/index"
    end

    get "/songs/new" do
        @genres = Genre.all
        erb :'/songs/new'
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        erb :'/songs/show'
    end

    post '/songs' do
        @song = Song.create(:name => params[:song][:name])
    
        @song.artist = Artist.find_or_create_by(name: params[:song][:artist])
    
        genre_selections = params[:song][:genres]
        genre_selections.each do |genre|
          @song.genres << Genre.find(genre)
        end
    
        @song.save
        flash[:message] = "Successfully created song."
        redirect to "/songs/#{@song.slug}"
    end

    get "/songs/:slug/edit" do
        @song = Song.find_by_slug(params[:slug])
        @genres = Genre.all
        erb :'/songs/edit'
    end

    patch '/songs/:slug' do
        song = Song.find_by_slug(params[:slug])
        song.artist = Artist.find_or_create_by(name: params[:song][:artist])
    
        genre_selections = params[:song][:genres]
        genre_selections.each do |genre|
          song.genres << Genre.find(genre)
        end
    
        song.save
        flash[:message] = "Successfully updated song."
        redirect to "/songs/#{song.slug}"
    end
        
end