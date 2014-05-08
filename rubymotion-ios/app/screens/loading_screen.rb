class LoadingScreen < PM::Screen
  title "Starting Up"

  attr_accessor :background_image

  def will_appear
    set_attributes self.view, {
      background_color: hex_color("#FFFFFF")
    }
  	@background_image.frame = view.frame.dup
  end

  def load_users
  	@background_image.image = UIImage.imageNamed("background.users.jpg")
  	User.fetch_all do |data|
      User.set(data)
  		load_beers
  	end
  end

  def load_beers
  	@background_image.image = UIImage.imageNamed("background.beers.jpg")
  	Beer.fetch_all do |data|
  		Beer.set(data, false)
  		App.notification_center.post 'FetchComplete'
  	end
  end

  def on_load
    @background_image = UIImageView.new
    
    view.addSubview(@background_image)
  	load_users
  end
end