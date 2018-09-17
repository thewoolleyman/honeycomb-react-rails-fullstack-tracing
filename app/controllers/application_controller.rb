class ApplicationController < ActionController::Base
  around_action :wrap_in_tracing_span

  private

  def wrap_in_tracing_span
    with_span("#{controller_name}##{action_name}") do
      yield
    end
  end
end
