class OnTapScreen < ProMotion::TableScreen

  title "On Tap"
	tab_bar_item title: "On Tap", icon: "88-beer-mug.png"

  attr_accessor :active_user, :beer_ids

  def motionEnded(motion, withEvent:event)
    if (motion == UIEventSubtypeMotionShake)
      beer = Beer[(@beer_ids - App.delegate.active_user.beer_ids).sample]
      App.alert(beer.name, {message: "Now order it!"})
    end
  end

	def on_load
    @data =  Beer.ontap
    @beer_ids ||= Beer.ontap.inject([]) {|o,v| o += v[1]; o }.map(&:id)

    @tap_user_observer = App.notification_center.observe 'ChangedUser' do |notification|
      update_table_data
      undrank = @beer_ids - App.delegate.active_user.beer_ids
      set_tab_bar_badge(undrank.count) if undrank.count > 0
    end    
  end

  def table_data
    @data ||= {}
    @data.map {|name, types| 
      {
        title: "#{name} (#{types.count})",
        cells: types.map { |t|
          drank = UIImage.imageNamed("undrank")
          if App.delegate.active_user && App.delegate.active_user.drank?(t.id)
            drank = UIImage.imageNamed("drank")
          end
          { 
            title: t.name,
            cell_style: UITableViewCellStyleSubtitle,
            image: { image: drank, radius: 20 },
          }
        }
      }
    }
  end

  def swap_content_controller(screen_class)
    App.delegate.slide_menu.controller(content: screen_class)
  end

end



    