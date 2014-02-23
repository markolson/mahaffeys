class HomeScreen < PM::Screen
  title "Home"

  def will_appear
    set_attributes self.view, {
      background_color: hex_color("#FFFFFF")
    }
  end
end