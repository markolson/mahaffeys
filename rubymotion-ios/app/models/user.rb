class User
  attr_accessor :id, :name, :beer_ids, :beers
  def initialize(id, name, beer_ids)
    @id = id.to_s
    @name = name
    @beer_ids = (beer_ids || []).map(&:to_s)
  end

  def self.[](id)
    user = User.all[id.to_s]
    user = User.new(user['id'].to_s, user['name'], user['beers'])
    return user
  end

  def to_json
    {"id"=> @id, "name"=> @name, "beer_count"=> beer_count}
  end

  def beer_count
    @beer_ids.count
  end

  def beers
    @beers = @beer_ids.group_by{ |x| Beer[x].type }
  end

  def drank?(id)
    beer_ids.include?(id.to_s)
  end

  def update(&callback)
    conn = AFMotion::HTTP.get("http://www.mahaffeyspub.com/beer/api.php?action=getMembers&member_id=#{@id}&beer_list=true") do |result|
      if result.body
        e = Pointer.new(:object)
        user_blob = NSJSONSerialization.JSONObjectWithData(result.body.dataUsingEncoding(NSUTF8StringEncoding), options:0, error: e).first
        Beer.set(BW::JSON.generate(user_blob['beers']).to_s, false)
        @beers = nil
        u = @@all[@id].dup
        u['beers'] = user_blob['beers'].map {|x| x['id'] }
        @beer_ids = (u['beers'] || []).map(&:to_s)
        @@all[@id.to_s] = u
        User.persist
        callback.call if callback
      else
        Motion::Blitz.error
      end
    end
  end

  def self.all
    @@all
  end

  @@all = {}
  def self.set(data)
    to_parse = data.kind_of?(String) ? data.dataUsingEncoding(NSUTF8StringEncoding) : data
    json = BW::JSON.parse(to_parse)
    json.each {|user, value|
      @@all[user['id'].to_s] = user
    }
    User.persist
    @@all
  end

  def self.persist
    data = User.all.map { |i,u|
      User.all[i]
    }
    App::Persistence['json_users'] = BW::JSON.generate(data).to_s
  end

  def self.fetch_all(&callback)
    #if App::Persistence['json_users']
    #  callback.call App::Persistence['json_users']
    #  return
    #end
    conn = AFMotion::HTTP.get("http://www.mahaffeyspub.com/beer/api.php?action=getMembers") do |result|
      if result.body
        Motion::Blitz.dismiss
        callback.call result.body
      else
        Motion::Blitz.error
        p "ERROR: #{result.error.localizedDescription}"
        callback.call App::Persistence['json_users'] || {}
      end
    end

    Motion::Blitz.show('Grabbing Member List', :gradient).sharedView.when_tapped do
      conn.cancel
    end
  end
end