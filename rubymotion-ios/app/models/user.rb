class User
	attr_accessor :id, :name, :beer_ids, :beers
	def initialize(id, name, beer_ids)
		@id = id
		@name = name
		@beer_ids = beer_ids.map(&:to_i)
	end

	def self.[](id)
		return User.all[id]
	end

	def beer_count
		@beer_ids.count
	end

	def beers
		@beers ||= @beer_ids.group_by{ |x| Beer[x].type }
	end

	def drank?(id)
		beer_ids.include?(id)
	end

	def self.all
		@@all
	end

	@@all = {}
	def self.set(data)
		data.each {|user|
			@@all[user['id'].to_i] = User.new(user['id'].to_i, user['name'], user['beers'])
		}
		@@all
	end

	def self.fetch_all(&callback)
		conn = AFMotion::JSON.get("http://mahaffeys.herokuapp.com/users/all") do |result|
      if result.success?
        callback.call result.object
      else
      	Motion::Blitz.error
        callback.call App::Persistence['users']
      end
    end

    Motion::Blitz.show('Grabbing Member List', :gradient).sharedView.when_tapped do
    	conn.cancel
    end
	end
end