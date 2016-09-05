class WindowChannel < ApplicationCable::Channel
  def subscribed
    @window_id = SecureRandom.uuid
    stream_from "window:#{@window_id}"
  end
end
