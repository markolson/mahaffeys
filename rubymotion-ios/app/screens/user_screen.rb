class UserScreen < ProMotion::TableScreen

  title "Mark Olson"
  tab_bar_item title: "You", icon: "111-user.png"

  def tableView(table_view, viewForFooterInSection: index)
    UIView.new
  end

  Notifier = Motion::Blitz
  attr_accessor :active_user, :award_bar

	def on_load
    set_nav_bar_button :left, title: "Find", action: 'open_user_search', system_icon: :search
    set_nav_bar_button :right, title: "Compare", action: nil

    tableView.tableFooterView = UIView.new.initWithFrame(CGRectZero)
    set_user([3162])
  end

  def open_user_search
    @finder = UserSearch.new
    @finder.callback = self
    @finder.title = "Change User"
    open_screen @finder, modal: true
  end

  def set_award_bar(results)
    self.table_view.tableHeaderView = nil
    return if results.nil?
    @award_bar = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 320, 44))
    @award_bar.autoresizingMask = UIViewAutoresizingFlexibleWidth
    @award_bar.backgroundColor = results[1]
    @award_bar.textAlignment = NSTextAlignmentCenter
    @award_bar.textColor = UIColor.whiteColor
    @award_bar.text = "#{results[0]} Beer Club Member"
    self.table_view.tableHeaderView = @award_bar
  end


  def set_user(user)
    @active_user = User[user[0].to_i]
    self.title = @active_user.name
    @data = {}
    set_award_bar(ClubStatus.convert(@active_user.beer_count))
    return unless @active_user
    @data =  @active_user.beers
    update_table_data
  end

  def table_data
    @data ||= {}

    @data.map {|name, types| 
      {
        title: "#{name} (#{types.count})",
        cells: types.map { |t|
          { 
            title: t.name,
            cell_style: UITableViewCellStyleSubtitle,
            image: { image: UIImage.imageNamed("drank") , radius: 20 },
          }
        }
      }
    }
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end



    