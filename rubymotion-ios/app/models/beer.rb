class Beer
	def self.[](id)
		return Beer.all[id]
	end

	def self.all
		@@all
	end

	def self.ontap
		@@all.values.select {|x| x.active }.group_by{|x| 
				x.type 
			}
	end

	@@all = NSMutableDictionary.new
	def self.set(data)
		template = Struct.new(:id, :name, :type, :active)
		mapping = {
			'B' => 'Bottles & Cans',
			'C' => 'Casks',
			'D' => 'Drafts'
		}
		data.each {|beer|
			@@all.setObject(template.new(beer['id'].to_i, beer['name'], mapping[beer['type']], beer['active']), forKey:beer['id'].to_i)
		}
		@@all = @@all.select{|x| !x.nil? }
		App::Persistence['beers'] = data
	end

	def self.fetch_all(&callback)
		Motion::Blitz.show('Grabbing Beers', :gradient)

		AFMotion::JSON.get("http://192.168.1.8:9292/beers/all") do |result|
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