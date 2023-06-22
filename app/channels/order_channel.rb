class OrderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "order_success"
  end

  def unsubscribed
  end
end
