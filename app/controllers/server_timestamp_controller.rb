class ServerTimestampController < ApplicationController
  def show
    render json: { server_timestamp: DateTime.now.strftime('%Q') }.as_json
  end
end
