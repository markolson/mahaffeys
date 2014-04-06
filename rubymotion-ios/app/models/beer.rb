class Beer
	attr_accessor :id, :name, :type, :active
	
	def initialize(id, name, type, active)
		@id = id
		@name = name
		@type = type
		@active = active
	end

	def self.[](id)
		return Beer.all[id]
	end

	def self.all
		@@all.select{|x| !x.nil? }
	end

	def self.ontap
		@@all.values.select{|x| !x.nil? }.select {|x| x.active }.group_by{|x| 
				x.type 
			}
	end

	@@all = {}
	def self.set(data)
		mapping = {
			'B' => 'Bottles & Cans',
			'C' => 'Casks',
			'D' => 'Drafts'
		}
		data.each {|beer|
			@@all[beer['id'].to_i] = Beer.new(beer['id'].to_i, beer['name'], mapping[beer['type']], beer['active'])
		}
		App::Persistence['beers'] = data
	end

	def self.fetch_all(&callback)
		Motion::Blitz.show('Grabbing Beers', :gradient)

		AFMotion::JSON.get("http://10.0.1.22:9292/beers/all") do |result|
      if result.success?
				Motion::Blitz.dismiss
        callback.call result.object
      else
      	Motion::Blitz.error
        callback.call App::Persistence['beers']
      end
    end
	end
end