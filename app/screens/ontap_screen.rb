class OnTapScreen < ProMotion::TableScreen

  title "On Tap"
	tab_bar_item title: "On Tap", icon: "88-beer-mug.png"

	def on_load
    set_tab_bar_badge (tab_bar_item[:badge_number] || 0) + 1
  end

  def table_data
    [{
      title: "Beers",
      cells: [{
        title: 'OVERWRITE THIS METHOD',
        action: :swap_content_controller,
        arguments: HomeScreen
      }]
    }]
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end



    