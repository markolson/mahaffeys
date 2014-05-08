class AppDelegate < PM::Delegate

  attr_accessor :active_user
  def on_load(app, options)
  	open LoadingScreen
  	@reload_observer = App.notification_center.observe 'FetchComplete' do |notification|
      #TestFlight.passCheckpoint("FetchComplete")
    	ready
  	end

    @user_observer = App.notification_center.observe 'ChangedUser' do |notification|
      @active_user =  notification.userInfo[:user]
      App::Persistence['user'] = @active_user.id
      #TestFlight.passCheckpoint("ChangedUser")
    end    
  end

  def ready
  	@ontap = OnTapScreen.new(nav_bar: true)
  	@user = UserScreen.new(nav_bar: true)
  	@events = HomeScreen.new(nav_bar: true)
  	open_tab_bar @ontap, @user, @events
  	open_tab App::Persistence['user'].nil? ? 0 : 1
  end
end