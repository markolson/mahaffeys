class Beer
	attr_accessor :id, :name, :type
	
	def initialize(id, name, type)
		@id = id
		@name = name
		@type = type
	end

	def self.[](id)
		return Beer.all[id]
	end

	def self.all
		@@all.select{|x| !x.nil? }
	end

	@@all = []
	def self.set(data)
		mapping = {
			'B' => 'Bottles & Cans',
			'C' => 'Casks',
			'D' => 'Drafts'
		}
		data.each {|beer|
			@@all[beer['id']] = Beer.new(beer['id'].to_i, beer['name'], mapping[beer['type']])
		}
	end

	def self.fetch_all(&callback)
		Motion::Blitz.show('Grabbing Beers')

		AFMotion::JSON.get("http://192.168.0.132:9292/beers/all") do |result|
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