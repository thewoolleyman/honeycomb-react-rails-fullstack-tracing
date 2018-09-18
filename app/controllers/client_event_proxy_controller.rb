class ClientEventProxyController < ApplicationController
  # POST /client_event_proxy.json
  def create
    event = params.fetch(:event).to_h
    start_timestamp_string = event.fetch(:timestamp)
    event.delete('timestamp')
    start = Time.at(start_timestamp_string.to_i / 1000)
    # the Ruby libhoney API wants the timestamp specified separately as a Ruby Time object,
    # not as part of the event data
    send_event(event, start)

    # could return more info, but for this example just return empty response
    render json: {}.as_json
  end
end
