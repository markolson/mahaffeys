class UserScreen < ProMotion::TableScreen

  title "Mark Olson"
  tab_bar_item title: "You", icon: "111-user.png"
  searchable

  def tableView(table_view, viewForFooterInSection: index)
    UIView.new
  end

  Notifier = Motion::Blitz

	def on_load
    set_nav_bar_button :left, title: "Find", action: 'open_user_search', system_icon: :search
    set_nav_bar_button :right, title: "Compare", action: nil

    tableView.tableFooterView = UIView.new.initWithFrame(CGRectZero)
    fetch_data
  end

  def open_user_search
    @finder = UserSearch.new
    @finder.callback = self
    @finder.title = "Change User"
    open_screen @finder, modal: true
  end

  def set_user(user)
    self.title = user[1]
    @data = {}
    update_table_data
    fetch_data
  end


  def fetch_data(user_id=3162)
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

    @data = {
      "Bottles & Cans" => [],
      "Casks" => [],
      "Drafts" => drafts
    }
    update_table_data
  end


  def table_data
    @data ||= {}

    @data.map {|name, types| 
      {
        title: name,
        cells: types.map { |t|
          { 
            title: t,
            cell_style: UITableViewCellStyleSubtitle,
            image: { image: (rand(4) % 4 == 0 ? UIImage.imageNamed("drank") : UIImage.imageNamed("undrank") ), radius: 20 },
          }
        }
      }
    }
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end



    