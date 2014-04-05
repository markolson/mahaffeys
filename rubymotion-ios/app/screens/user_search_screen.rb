class UserSearch < ProMotion::TableScreen
  searchable

  def on_load
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0) if (UIDevice.currentDevice.systemVersion.floatValue >= 7.0)
  end

  attr_accessor :callback 

  def table_data
    [{
      title: nil,
      cells: User.all.map do |user|
      {
        title: user.name,
        subtitle: "##{user.id}",
        search_text: "#{user.id}",
        action: :on_click,
        arguments: [user.id,  user.name]
      }
      end
    }]
  end

  def on_click(user)
    callback.set_user(user)
    close_screen(animated: true)
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end