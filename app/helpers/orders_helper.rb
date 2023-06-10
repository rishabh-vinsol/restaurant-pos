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
end
