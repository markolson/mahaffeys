class UserSearch < ProMotion::TableScreen
  searchable

  def on_load
    
  end

  attr_accessor :callback 

  def users
    [
      {id: 3191, name: 'Eric Sauter'},
      {id: 3162, name: 'Mark Olson'},

    ]
  end

  def table_data
    [{
      title: nil,
      cells: users.map do |user|
      {
        title: user[:name],
        subtitle: "##{user[:id]}",
        search_text: "#{user[:id]}",
        action: :on_click,
        arguments: [user[:id],  user[:name]]
      }
      end
    }]
  end

  def on_click(user)
    p "calling back"
    p callback
    callback.set_user(user)
    p "closing screen"
    close_screen(animated: true)
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end