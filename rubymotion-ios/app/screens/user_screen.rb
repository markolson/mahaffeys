class UserScreen < ProMotion::TableScreen

  title "You, Eventually."
  tab_bar_item title: "You", icon: "111-user.png"

  def tableView(table_view, viewForFooterInSection: index)
    UIView.new
  end

  Notifier = Motion::Blitz
  attr_accessor :active_user, :award_bar, :updater

	def on_load
    set_nav_bar_button :left, title: "Find", action: 'open_user_search', system_icon: :search
    set_nav_bar_button :right, title: "Compare", action: nil

    tableView.tableFooterView = UIView.new.initWithFrame(CGRectZero) 

    @user_observer = App.notification_center.observe 'ChangedUser' do |notification|
      @active_user = nil
      update_table_data
      set_user(notification.userInfo[:user])
    end     
  end

  def set_user(user)
    @active_user = user
    self.title = @active_user.name
    Notifier.progress(0.0)
    @updater = Thread.new {
      update_table_data
      Notifier.dismiss
      @updater = nil
    }
  end

  def view_did_appear(animated) 
    return if animated
    if App::Persistence['user'] 
      set_user(User[App::Persistence['user']])
    else
      open_user_search
    end
  end

  def open_user_search
    return if @updater
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

  def table_data
    drank = UIImage.imageNamed("drank")
    undrank = UIImage.imageNamed("undrank")
    progress = 0
    return {} if @active_user.nil?
    set_award_bar(ClubStatus.convert(@active_user.beer_count))
    @active_user.beers.map {|name, types| 
      {
        title: "#{name} (#{types.count})",
        cells: types.map { |t|
          Dispatch::Queue.main.sync {
            progress += 1
            Notifier.progress(progress/@active_user.beer_count.to_f) if progress%50==0
          }
          { 
            title: Beer[t.to_i].name,
            image: { image: @active_user.drank?(t.to_i) ? drank : undrank , radius: 20 },
          }
        }
      }
    }
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end



    