class Beer
	def self.[](id)
		return Beer.all[id.to_s]
	end

	def self.all
		@@all
	end

	def self.ontap
		@@all.values.select {|x| x.in_stock }.group_by{|x| 
				x.type 
			}
	end

	@@all = NSMutableDictionary.new
	def self.set(data, reset=false)
		to_parse = data.kind_of?(String) ? data.dataUsingEncoding(NSUTF8StringEncoding) : data
		data = BW::JSON.parse(to_parse)
		template = Struct.new(:id, :name, :type, :in_stock)
		mapping = {
			'B' => 'Bottles & Cans',
			'C' => 'Casks',
			'D' => 'Drafts'
		}
		data.each {|beer|
			@@all.setObject(template.new(beer['id'].to_s, beer['name'], mapping[beer['type']], !reset && beer['in_stock'] == 'yes'), forKey:beer['id'].to_s)
		}
		@@all = @@all.select{|x| !x.nil? }

		Beer.persist
	end

  def self.persist
    data = Beer.all.map { |i,u|
      b = Beer.all[i]
      {"id" => b.id, "name" => b.name, "type" => b.type, "in_stock" => b.in_stock}
    }
    App::Persistence['json_beers'] = BW::JSON.generate(data).to_s
  end

	def self.fetch_all(&callback)
		Beer.set(App::Persistence['json_beers'], true) if App::Persistence['json_beers']
    #conn = AFMotion::JSON.get("http://mahaffeys.herokuapp.com/users/all") do |result|
    conn = AFMotion::HTTP.get("http://www.mahaffeyspub.com/beer/api.php?action=getBeers") do |result|
      if result.body
        callback.call result.body
        Motion::Blitz.dismiss
      else
        Motion::Blitz.error
        p "ERROR: #{result.error.localizedDescription}"
        callback.call App::Persistence['beers']
      end
    end

    Motion::Blitz.show('Grabbing Beers', :gradient).sharedView.when_tapped do
    	conn.cancel
    end    
	end
end