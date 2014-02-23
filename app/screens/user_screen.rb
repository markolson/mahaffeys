class UserScreen < ProMotion::TableScreen

  title "Mark Olson"
  searchable

	def on_load
    set_nav_bar_button :left, title: "Find", action: nil, system_icon: :search
    set_nav_bar_button :right, title: "Compare", action: nil
    
    set_tab_bar_item({ title: "You", icon: "user.png" })
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
          image: { image: (rand(2) % 2 == 0 ? UIImage.imageNamed("drank") : UIImage.imageNamed("undrank") ), radius: 20 },
        }
      }
    }]
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end



    