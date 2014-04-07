class UserSearch < ProMotion::TableScreen
  searchable

  def on_load
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) if (UIDevice.currentDevice.systemVersion.floatValue >= 7.0)
  end

  attr_accessor :callback 

  def table_data

    [{
      title: nil,
      cells: User.all.sort {|a,b| a[1].id <=> b[1].id}.map do |user|
      {
        title: user[1].name,
        subtitle: "##{user[1].id}",
        search_text: "#{user[1].id}",
        action: :on_click,
        arguments: [user[1].id,  user[1].name]
      }
      end
    }]
  end

  def on_click(user)
    p "clicked on #{user}"
    close_screen(animated: true)
    App.notification_center.post 'ChangedUser', nil, {user: User[user[0]] }
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end