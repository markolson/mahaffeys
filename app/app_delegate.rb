class AppDelegate < PM::Delegate
  def on_load(app, options)
  	@ontap = OnTapScreen.new(nav_bar: true)
  	@user = UserScreen.new(nav_bar: true)
  	@events = HomeScreen.new(nav_bar: true)

  	open_tab_bar @ontap, @user, @events
  	open_tab 1
  end
end