require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/user'        #Model class
require 'pry'
require 'json'

get '/' do
	erb :index
end

get '/users' do
  users = User.all
  user_list = []
  users.each do |user|
    user_list << { name: user.name, beer_count: user.beer_count }
  end
  user_list.to_json
end

after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end
