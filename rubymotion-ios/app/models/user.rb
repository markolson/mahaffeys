class User
	attr_accessor :id, :name, :beer_ids, :beer_count
	def initialize(id, name, beer_count)
		@id = id
		@name = name
		@beer_count = beer_count
		@beer_ids = []
	end

	def self.all
		@@all
	end

	@@all = []
	def self.set(data)
		data.each {|user|
			@@all << User.new(user['id'], user['name'], user['beer_count'])
		}
	end

	def self.fetch_all(&callback)
		Motion::Blitz.show('Grabbing Users')

		AFMotion::JSON.get("http://localhost:9292/users/all") do |result|
      if result.success?
				Motion::Blitz.success
        callback.call result.object
      else
      	Motion::Blitz.error
        callback.call nil
      end
    end
	end
end