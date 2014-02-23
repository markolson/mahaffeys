class UserScreen < ProMotion::TableScreen

  title "Mark Olson"
  tab_bar_item title: "You", icon: "111-user.png"
  searchable

	def on_load
    set_nav_bar_button :left, title: "Find", action: 'open_user_search', system_icon: :search
    set_nav_bar_button :right, title: "Compare", action: nil
  end

  def open_user_search
    @finder = UserSearch.new
    @finder.callback = self
    @finder.title = "Change User"
    open_screen @finder, modal: true
  end

  def set_user(user)
    self.title = user[1]
    p "Title is now #{title}"
  end


  def table_data

    drafts =   ["Brooklyn Hammarby Syndrome",
  "Courage Russian Imperial Stout",
  "Dogfish Head Birra Etrusca Bronze",
  "Dogfish Head Kvasir",
  "Dogfish Head Worldwide Stout",
  "Heavy Seas Black Cannon",
  "Hebrew Rejewvenator 2013",
  "Lagunitas Czech Pils",
  "Lagunitas IPA",
  "Lagunitas New Dogtown Pale",
  "Maine Beer King Titus",
  "Oliver's Scottish Ale",
  "Otter Creek Citra Mantra",
  "Rogue Farms 7 Hop IPA",
  "Sixpoint Mad Scientist #18: Brunswick Mumme",
  "Southern Tier IPA (Nitro)",
  "Terrapin Mosaic",
  "Uinta Hop Nosh",
  "Unibroue La Terrible"]

    [{
      title: "Bottles & Cans",
      cells: []
      },
      {
      title: "Casks",
      cells: []
      },
      {
      title: "Drafts",
      cells: drafts.map { |beer|
        { 
          title: beer,
          cell_style: UITableViewCellStyleSubtitle,
          image: { image: (rand(4) % 4 == 0 ? UIImage.imageNamed("drank") : UIImage.imageNamed("undrank") ), radius: 20 },
        }
      }
    }]
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end



    