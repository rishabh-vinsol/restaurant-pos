# Orders Helper
module OrdersHelper
  def pickup_time_options
    start_time =(Time.now + 1.hour).beginning_of_hour
    end_time = start_time.end_of_day

    time_options = []
    current_time = start_time

    while current_time <= end_time
      time_options << [current_time.strftime('%I:%M %p'), current_time.strftime('%H:%M')]
      current_time += 30.minutes
    end

    time_options
  end

  def order_status_bg(order)
    bg_class = ''
    if order.received?
      bg_class = 'bg-secondary'
    elsif order.cancelled?
      bg_class = 'bg-danger'
    elsif order.ready?
      bg_class = 'bg-primary'
    elsif order.picked_up?
      bg_class = 'bg-success'
    end
    bg_class
  end

  def order_tr_class(order)
    tr_class = ''
    if order.ready?
      tr_class = 'table-primary'
    elsif order.picked_up?
      tr_class = 'table-success'
    elsif order.cancelled?
      tr_class = 'table-danger'
    end
    tr_class
  end
end
