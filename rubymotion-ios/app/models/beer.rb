class Beer
	#attr_accessors :id, :name, :beer_ids
	@@all = {}
	def self.set(data)
		data.each {|beer|
			@@all[beer[:id]] = beer[:name]
		}
	end

	def self.fetch_all(&callback)
		Motion::Blitz.show('Grabbing Beers')

		AFMotion::JSON.get("http://localhost:9292/beers/all") do |result|
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