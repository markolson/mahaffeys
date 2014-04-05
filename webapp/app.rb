require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/namespace'
require './config/environments' #database configuration
require './models/user'        #Model class
require './models/beer'
require 'pry'

get '/' do
  erb :index
end

namespace '/users' do
  get '/all' do
    content_type 'application/json'
    users = User.all
    user_list = []
    users.each do |user|
      user_list << { id: user.id, name: user.name, beer_count: user.beers.length }
    end
    user_list.to_json
  end

  get '/search/:q' do
    "Test"
  end
end

namespace '/user' do
  get '/:id' do
    u = User.where(id: params[:id])
    u = User.where(name: params[:id]) if u.empty?
    return u.first.to_json if u.any?
    "User not found"
  end
end

namespace '/beers' do
  get '/all' do
    content_type 'application/json'
    Beer.all.to_json
  end
end

after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end