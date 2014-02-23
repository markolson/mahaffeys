class HomeScreen < PM::Screen
  title "Events"
  tab_bar_item title: "Events", icon: "83-calendar.png"

  def will_appear
    set_attributes self.view, {
      background_color: hex_color("#FFFFFF")
    }
  end
end