class StockChannel < ApplicationCable::Channel
  def subscribed
    stream_from "out_of_stock"
  end

  def unsubscribed
  end
end
