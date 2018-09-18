class ServerTimestampController < ApplicationController
  def show
    render plain: DateTime.now.strftime('%Q')
  end
end
